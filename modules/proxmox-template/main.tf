# Создание шаблонной ВМ из Cloud Image
resource "proxmox_virtual_environment_download_file" "cloud_image" {
  content_type = "iso"
  datastore_id = var.storage_pool
  node_name    = var.proxmox_node
  
  url          = var.cloud_image_url
  file_name    = basename(var.cloud_image_url)
  
  # Опционально: проверка целостности файла
  # checksum      = "sha256:..."
  # checksum_type = "sha256"
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
    file_id      = proxmox_virtual_environment_download_file.cloud_image.id
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
    timeout = "15m"
  }
  
  operating_system {
    type = "l26"
  }
  
  serial_device {}
  
  started = false # Шаблон не запускаем
  
  lifecycle {
    ignore_changes = [
      disk[0].size,
      tags
    ]
  }
}

# Преобразование VM в шаблон
resource "null_resource" "convert_to_template" {
  depends_on = [proxmox_virtual_environment_vm.template_vm]
  
  triggers = {
    vm_id = proxmox_virtual_environment_vm.template_vm.id
  }
  
  # Команда для конвертации VM в шаблон через Proxmox API
  provisioner "local-exec" {
    command = <<-EOT
      curl -k -X POST \
        -H "Authorization: PVEAPIToken=${var.pm_api_token_id}=${var.pm_api_token_secret}" \
        "${var.pm_api_url}/api2/json/nodes/${var.proxmox_node}/qemu/${var.template_vm_id}/template"
    EOT
    
    environment = {
      PM_API_URL           = var.pm_api_url
      PM_API_TOKEN_ID      = var.pm_api_token_id
      PM_API_TOKEN_SECRET  = var.pm_api_token_secret
      PROXMOX_NODE         = var.proxmox_node
      TEMPLATE_VM_ID       = var.template_vm_id
    }
  }
  
  # Ожидание завершения задачи
  provisioner "local-exec" {
    command = <<-EOT
      sleep 30
    EOT
  }
}
