# Создание шаблонной ВМ из Cloud Image
resource "proxmox_virtual_environment_file" "cloud_image" {
  content_type = "iso"
  datastore_id = var.storage_pool
  node_name    = var.proxmox_node
  
  source_file {
    path      = var.cloud_image_url
    file_name = basename(var.cloud_image_url)
  }
}

# Создание VM из Cloud Image
resource "proxmox_virtual_environment_vm" "template_vm" {
  node_name = var.proxmox_node
  vm_id     = var.template_vm_id
  name      = "ubuntu-cloud-template"
  tags      = ["template", "ubuntu", "cloud-init"]
  
  # Создание из Cloud Image
  disk {
    datastore_id = var.storage_pool
    interface    = "scsi0"
    size         = var.template_disk_size
    file_id      = proxmox_virtual_environment_file.cloud_image.id
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
  
  initialization {
    datastore_id = var.snippets_datastore_id
    
    # Базовый cloud-init конфиг для шаблона
    user_data = base64encode(<<-EOT
#cloud-config
package_update: true
package_upgrade: true
packages:
  - qemu-guest-agent
  - curl
  - wget
runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
  - cloud-init clean
ssh_pwauth: false
disable_root: true
EOT
    )
  }
  
  agent {
    enabled = true
    type    = "virtio"
    timeout = "15m"
  }
  
  operating_system {
    type = "l26"
  }
  
  serial_device {
    device = "socket"
  }
  
  started = false # Шаблон не запускаем
  
  lifecycle {
    ignore_changes = [
      disk[0].size,
      tags
    ]
  }
}

# Преобразование VM в шаблон
resource "proxmox_virtual_environment_vm" "template_conversion" {
  depends_on = [proxmox_virtual_environment_vm.template_vm]
  
  node_name = var.proxmox_node
  vm_id     = var.template_vm_id
  
  # Остановка VM перед конвертацией в шаблон
  started = false
  
  # Преобразование в шаблон
  template = true
  
  lifecycle {
    ignore_changes = [
      template # Избегаем циклических изменений
    ]
  }
}
