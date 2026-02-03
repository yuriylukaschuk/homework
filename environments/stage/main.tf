# Используем модуль вместо прямой конфигурации
module "ubuntu_vms" {
  source = "../../modules/proxmox-vm"

  # Метод создания: false = клонировать из шаблона
  create_from_cloud_image = var.create_from_cloud_image

  # Параметры Proxmox
  proxmox_node = var.proxmox_node

  # Параметры для клонирования (если create_from_cloud_image = false)
  template_vm_id = var.template_vm_id

  # Конфигурация VM
  vms = var.vms

  # Storage параметры
  storage_pool          = var.storage_pool
  snippets_datastore_id = "local"
  vm_pool               = var.vm_pool

  # Сетевые параметры
  network_bridge      = var.network_bridge
  gateway             = var.gateway
  network_cidr_suffix = tonumber(split("/", var.network_cidr)[1])
  dns_servers         = ["8.8.8.8", "1.1.1.1"]

  # Cloud-init параметры
  vm_admin_username = var.vm_admin_username
  ssh_public_key    = file("/root/.ssh/id_ed25519.pub")
  timezone          = "Europe/Moscow"

  # Дополнительные настройки
  autostart_vms   = true
  additional_tags = ["stage", "kubernetes"]
}

# Выводим IP адреса созданных ВМ
output "vm_ips" {
  value     = module.ubuntu_vms.vm_ip_addresses
  sensitive = true
}

output "vm_ids" {
  value = module.ubuntu_vms.vm_ids
}

output "cloud_init_file_ids" {
  value = module.ubuntu_vms.cloud_init_file_ids
}
