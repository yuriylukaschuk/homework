# Cloud-init файл для шаблонной VM
resource "proxmox_virtual_environment_file" "template_cloud_init" {
  count = var.create_template ? 1 : 0

  content_type = "snippets"
  datastore_id = var.snippets_datastore_id
  node_name    = var.proxmox_node
  
  source_raw {
    data = <<-EOT
#cloud-config
package_update: true
package_upgrade: true
packages:
  - qemu-guest-agent
runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
  - cloud-init clean
ssh_pwauth: false
disable_root: true
final_message: "Template is ready for conversion"
EOT
    
    file_name = "cloud-init-template.yml"
  }
}

# Условное создание шаблона ИЛИ рабочих ВМ
# Ресурс cloud_image используется в обоих случаях

resource "proxmox_virtual_environment_download_file" "cloud_image" {
  # Скачиваем только если create_template = true ИЛИ create_from_cloud_image = true
  count = (var.create_template || var.create_from_cloud_image) ? 1 : 0

  content_type = "iso"
  datastore_id = var.storage_pool
  node_name    = var.proxmox_node
  
  url          = var.cloud_image_url
  file_name    = basename(var.cloud_image_url)
}

# Шаблонная VM - создается только если create_template = true
resource "proxmox_virtual_environment_vm" "template_vm" {
  count = var.create_template ? 1 : 0

  node_name = var.proxmox_node
  vm_id     = var.template_vm_id
  name      = "ubuntu-cloud-template"
  tags      = ["template", "terraform"]
  
  # Создание из Cloud Image
  disk {
    datastore_id = var.storage_pool
    interface    = "scsi0"
    size         = var.template_disk_size
    file_id      = proxmox_virtual_environment_download_file.cloud_image[0].id
    file_format  = "raw"
  }
  
  cpu {
    cores    = var.template_cores
    sockets  = 1
    type     = "host"
  }
  
  memory {
    dedicated = var.template_memory
  }
  
  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }
  
  # Cloud-init для шаблона
  initialization {
    datastore_id      = var.snippets_datastore_id
    user_data_file_id = proxmox_virtual_environment_file.template_cloud_init[0].id
  }
  
  agent {
    enabled = true
    timeout = "10m"
  }
  
  operating_system {
    type = "l26"
  }
  
  serial_device {}
  
  started = true
  
  lifecycle {
    ignore_changes = [
      tags,
      disk[0].size
    ]
  }
}

# Cloud-init для рабочих ВМ - создается только если create_template = false
resource "proxmox_virtual_environment_file" "cloud_init" {
  for_each = (!var.create_template) ? var.vms : {}

  content_type = "snippets"
  datastore_id = var.snippets_datastore_id
  node_name    = var.proxmox_node
  
  source_raw {
    data = <<-EOT
#cloud-config
hostname: ${each.key}
manage_etc_hosts: true
users:
  - name: ${var.vm_admin_username}
    ssh-authorized-keys:
      - ${var.ssh_public_key}
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    shell: /bin/bash
    lock_passwd: true
packages:
  - qemu-guest-agent
  - curl
  - wget
runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
  - hostnamectl set-hostname ${each.key}
package_update: true
package_upgrade: true
ssh_pwauth: false
disable_root: true
timezone: ${var.timezone}
${var.additional_cloud_config}
EOT
    
    file_name = "cloud-init-${each.key}.yml"
  }
}

# Рабочие ВМ - создаются только если create_template = false
# Могут создаваться либо из cloud image, либо клонированием из шаблона
resource "proxmox_virtual_environment_vm" "virtual_machines" {
  for_each = (!var.create_template) ? var.vms : {}
  
  node_name = var.proxmox_node
  vm_id     = each.value.vmid
  name      = each.key
  pool_id   = var.vm_pool
  tags      = concat(["terraform", "auto-created"], var.additional_tags)
  
  # Метод 1: Клонирование из шаблона
  dynamic "clone" {
    for_each = (!var.create_from_cloud_image) ? [1] : []
    content {
      vm_id = var.template_vm_id
      full  = true
      retries = 3
    }
  }
  
  # Метод 2: Создание из Cloud Image
  dynamic "disk" {
    for_each = var.create_from_cloud_image ? [1] : []
    content {
      datastore_id = var.storage_pool
      interface    = "scsi0"
      size         = each.value.disk_size
      file_id      = proxmox_virtual_environment_download_file.cloud_image[0].id
      file_format  = "raw"
      discard      = "on"
    }
  }
  
  cpu {
    cores    = each.value.cores
    sockets  = 1
    type     = "host"
    numa     = false
  }
  
  memory {
    dedicated = each.value.memory
  }
  
  # Диск для клонирования (если не создаём из Cloud Image)
  dynamic "disk" {
    for_each = (!var.create_from_cloud_image) ? [1] : []
    content {
      datastore_id = var.storage_pool
      interface    = "scsi0"
      size         = each.value.disk_size
      file_format  = "raw"
      discard      = "on"
    }
  }
  
  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }
  
  initialization {
    datastore_id      = var.snippets_datastore_id
    user_data_file_id = proxmox_virtual_environment_file.cloud_init[each.key].id
    
    ip_config {
      ipv4 {
        address = "${each.value.ip_address}/${var.network_cidr_suffix}"
        gateway = var.gateway
      }
    }
    
    dns {
      servers = var.dns_servers
    }
  }
  
  agent {
    enabled = true
    timeout = var.create_from_cloud_image ? "15m" : "5m"
  }
  
  operating_system {
    type = "l26"
  }
  
  serial_device {}
  
  started = var.autostart_vms
  
  lifecycle {
    ignore_changes = [
      initialization[0].user_data_file_id,
      tags,
      clone[0].vm_id
    ]
  }
}
