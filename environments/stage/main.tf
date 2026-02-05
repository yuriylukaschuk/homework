# Этап 1: Создание шаблонной VM
module "create_template" {
  source = "../../modules/proxmox-vm"

  # Режим создания шаблона
  create_template = true
  # Метод создания VM (true = из Cloud Image, false = клонировать)
  create_from_cloud_image = false

  # Параметры шаблона
  proxmox_node          = var.proxmox_node
  template_vm_id        = var.template_vm_id
  storage_pool          = var.storage_pool
  snippets_datastore_id = "local"
  network_bridge        = var.network_bridge

  # Параметры шаблонной VM
  template_disk_size = 20
  template_cores     = 1
  template_memory    = 1024
  cloud_image_url    = var.cloud_image_url

  # Остальные параметры (обязательные, но пустые)
  vms                     = {}
  vm_pool                 = ""
  gateway                 = var.gateway
  network_cidr_suffix     = tonumber(split("/", var.network_cidr)[1])
  dns_servers             = var.dns_servers
  vm_admin_username       = var.vm_admin_username
  ssh_public_key          = file(var.proxmox_ssh_public_key)
  timezone                = var.timezone
  autostart_vms           = true
  additional_tags         = []
  additional_cloud_config = ""
}

# Этап 2: Создание рабочих ВМ из шаблона
module "ubuntu_vms" {
  source = "../../modules/proxmox-vm"

  # Режим создания рабочих ВМ через клонирование
  create_template         = false
  create_from_cloud_image = false

  # Параметры Proxmox
  proxmox_node = var.proxmox_node

  # ID шаблона
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
  dns_servers         = var.dns_servers

  # Cloud-init параметры
  vm_admin_username = var.vm_admin_username
  ssh_public_key    = file(var.proxmox_ssh_public_key)
  timezone          = var.timezone

  # Дополнительные настройки
  autostart_vms   = true
  additional_tags = ["stage", "kubernetes"]
}

# Выводы
output "template_instruction" {
  value = module.create_template.template_status
}

output "template_vm_id" {
  value = module.create_template.template_vm_id
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
