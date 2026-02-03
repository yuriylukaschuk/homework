# 1. Создание шаблона
module "proxmox_template" {
  source = "../../modules/proxmox-template"
  
  proxmox_node     = var.proxmox_node
  template_vm_id   = var.template_vm_id
  storage_pool     = var.storage_pool
  network_bridge   = var.network_bridge
  
  # Опционально переопределить параметры шаблона
  template_disk_size = 30
  template_cores     = 4
  template_memory    = 4096
}

# 2. Создание рабочих ВМ из шаблона
module "ubuntu_vms" {
  source = "../../modules/proxmox-vm"
  
  depends_on = [module.proxmox_template] # Важно: дождаться создания шаблона
  
  # Метод создания: false = клонировать из шаблона
  create_from_cloud_image = false # Теперь всегда false, используем шаблон
  
  # Параметры Proxmox
  proxmox_node = var.proxmox_node
  
  # ID созданного шаблона
  template_vm_id = module.proxmox_template.template_vm_id
  
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

# Выводим ID созданного шаблона
output "template_vm_id" {
  value = module.proxmox_template.template_vm_id
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
