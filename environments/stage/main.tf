# 1. Создание шаблона
module "proxmox_template" {
  source = "../../modules/proxmox-template"
  
  # Proxmox параметры
  proxmox_node   = var.proxmox_node
  template_vm_id = var.template_vm_id
  
  # API параметры для конвертации в шаблон
  pm_api_url           = var.pm_api_url
  pm_api_token_id      = var.pm_api_token_id
  pm_api_token_secret  = var.pm_api_token_secret
  
  # Остальные параметры
  storage_pool     = var.storage_pool
  network_bridge   = var.network_bridge
}

# 2. Создание рабочих ВМ из шаблона
module "ubuntu_vms" {
  source = "../../modules/proxmox-vm"
  
  depends_on = [module.proxmox_template] # Важно: дождаться создания шаблона
  
  # Метод создания: false = клонировать из шаблона
  create_from_cloud_image = false
  
  # Параметры Proxmox
  proxmox_node = var.proxmox_node
  
  # ID созданного шаблона
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

# Выводим информацию о созданных ресурсах
output "template_created" {
  value = "Template with ID ${var.template_vm_id} has been created"
}

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
