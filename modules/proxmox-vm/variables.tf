# Основные параметры
variable "create_from_cloud_image" {
  description = "Создавать ВМ из Cloud Image вместо клонирования"
  type        = bool
  default     = false
}

variable "proxmox_node" {
  description = "Имя ноды Proxmox"
  type        = string
  default     = "pve"
}

# Параметры для клонирования
variable "template_vm_id" {
  description = "ID шаблонной VM для клонирования"
  type        = number
  default     = null
}

# Конфигурация VM
variable "vms" {
  description = "Конфигурация создаваемых ВМ"
  type = map(object({
    vmid       = number
    cores      = number
    memory     = number
    disk_size  = number
    ip_address = string
  }))
}

variable "vm_pool" {
  description = "Пул для ВМ"
  type        = string
  default     = ""
}

variable "autostart_vms" {
  description = "Автоматически запускать VM после создания"
  type        = bool
  default     = true
}

# Сетевые параметры
variable "network_bridge" {
  description = "Сетевой мост Proxmox"
  type        = string
  default     = "vmbr0"
}

variable "gateway" {
  description = "Шлюз по умолчанию"
  type        = string
}

variable "network_cidr_suffix" {
  description = "CIDR суффикс (например, 24 для /24)"
  type        = number
  default     = 24
}

variable "dns_servers" {
  description = "DNS серверы"
  type        = list(string)
  default     = ["8.8.8.8", "1.1.1.1"]
}

# Storage параметры
variable "storage_pool" {
  description = "Хранилище для ВМ"
  type        = string
  default     = "hdd-thin"
}

variable "snippets_datastore_id" {
  description = "Хранилище для cloud-init snippets"
  type        = string
  default     = "local"
}

# Параметры cloud-init
variable "vm_admin_username" {
  description = "Имя административного пользователя ВМ"
  type        = string
  default     = "admin"
}

variable "ssh_public_key" {
  description = "SSH публичный ключ"
  type        = string
}

variable "timezone" {
  description = "Часовой пояс"
  type        = string
  default     = "Europe/Moscow"
}

variable "additional_cloud_config" {
  description = "Дополнительная конфигурация cloud-init"
  type        = string
  default     = ""
}

variable "additional_tags" {
  description = "Дополнительные теги для VM"
  type        = list(string)
  default     = []
}
