# Модуль для создания ВМ только через клонирование шаблона

# Cloud-init для каждой VM
resource "proxmox_virtual_environment_file" "cloud_init" {
  for_each = var.vms

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

# Создание ВМ только через клонирование шаблона
resource "proxmox_virtual_environment_vm" "virtual_machines" {
  for_each = var.vms
  
  depends_on = [proxmox_virtual_environment_file.cloud_init]
  
  node_name = var.proxmox_node
  vm_id     = each.value.vmid
  name      = each.key
  pool_id   = var.vm_pool
  tags      = concat(["terraform", "auto-created"], var.additional_tags)
  
  # Клонирование из шаблона
  clone {
    vm_id = var.template_vm_id
    full  = true
    retries = 3 # Повторные попытки при ошибках
  }
  
  # Общие параметры CPU и памяти
  cpu {
    cores    = each.value.cores
    sockets  = 1
    type     = "host"
    numa     = false
  }
  
  memory {
    dedicated = each.value.memory
  }
  
  # Изменение размера диска после клонирования
  disk {
    datastore_id = var.storage_pool
    interface    = "scsi0"
    size         = each.value.disk_size
    file_format  = "raw"
    discard      = "on"
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
    timeout = "5m"
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
      clone[0].vm_id # Игнорируем изменения ID шаблона
    ]
  }
}
