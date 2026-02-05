# variables.tf
# Этот файл описывает КАКИЕ переменные нужны, но не содержит их значений
# Этот файл МОЖНО коммитить в Git

variable "pm_api_url" {
  description = "URL для подключения к API Proxmox"
  type        = string
  sensitive   = true # Важно: помечаем как чувствительную
}

variable "pm_api_token_id" {
  description = "ID токена API Proxmox"
  type        = string
  sensitive   = true
}

variable "pm_api_token_secret" {
  description = "Секретная часть токена API Proxmox"
  type        = string
  sensitive   = true
}

variable "pm_tls_insecure" {
  description = "Ignore TLS certificate errors"
  type        = bool
  default     = true
}

variable "pm_password" {
  description = "Пароль пользователя Proxmox (если не используете токен)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "vm_admin_username" {
  description = "Имя административного пользователя ВМ"
  type        = string
  default     = "admin" # Не root!
}

variable "proxmox_ssh_username" {
  description = "Имя пользователя SSH для доступа к Proxmox"
  type        = string
  default     = "terraform-svc"
}

variable "proxmox_ssh_password" {
  description = "Пароль пользователя SSH для доступа к Proxmox"
  type        = string
  sensitive   = true
  default     = "" # Пароль пользователя terraform-svc
}

variable "proxmox_ssh_public_key" {
  description = "Путь к приватному SSH ключу для доступа к Proxmox"
  type        = string
}

variable "proxmox_ssh_private_key" {
  description = "Путь к приватному SSH ключу для доступа к Proxmox"
  type        = string
}

################## Обычные (не секретные) переменные ##################

variable "timeout" {
  description = "ID шаблона ВМ для клонирования"
  type        = number
  default     = 600
}

variable "additional_cloud_config" {
  description = "Дополнительная конфигурация cloud-init"
  type        = string
}

variable "additional_tags" {
  description = "Дополнительные теги для VM"
  type        = list(string)
  default     = ["stage"]
}

# Обычные (не секретные) переменные
variable "proxmox_node" {
  description = "Имя ноды Proxmox (обычно 'pve')"
  type        = string
  default     = "pve" # Значение по умолчанию
}

variable "storage_pool" {
  description = "Хранилище для дисков ВМ (должно поддерживать images)"
  type        = string
  default     = "hdd-thin"
}

# Дополнительные настройки модуля
variable "autostart_vms" {
  description = "Автоматически запускать VM после создания"
  type        = bool
  default     = true
}

variable "vm_pool" {
  description = "Пул для ВМ"
  type        = string
  default     = "terraform-pool"
}

# Настройки сети
variable "network_bridge" {
  description = "Сетевой мост для ВМ"
  type        = string
}

variable "network_cidr" {
  description = "CIDR внутренней сети"
  type        = string
}

variable "gateway" {
  description = "Шлюз по умолчанию"
  type        = string
}

variable "dns_servers" {
  description = "DNS серверы для ВМ"
  type        = list(string)
}

variable "timezone" {
  description = "Часовой пояс для ВМ"
  type        = string
}

# Настройки шаблона ВМ
variable "template_vm_id" {
  description = "ID шаблона ВМ для клонирования"
  type        = number
  default     = 9000 # ID вашего шаблона
}

# Настройки ВМ
variable "vms" {
  description = "Конфигурация создаваемых ВМ"
  type = map(object({
    vmid       = optional(number, 110)
    cores      = optional(number, 1)
    memory     = optional(number, 1024)
    disk_size  = optional(number, 20)
    ip_address = optional(string, "10.10.10.110")
  }))
  default = {}
}

variable "iso_storage" {
  description = "Хранилище для ISO образов"
  type        = string
}

variable "cloud_image_file" {
  description = "Cloud Image файл в хранилище Proxmox"
  type        = string
}

variable "snippets_datastore_id" {
  description = "Хранилище для cloud-init snippets"
  type        = string
}

variable "use_local_cloud_image" {
  description = "Использовать локальный Cloud Image вместо скачивания"
  type        = bool
}

variable "local_cloud_image_storage" {
  description = "Хранилище где находится локальный Cloud Image"
  type        = string
  default     = "local"
}

variable "create_template" {
  description = "Создавать шаблонную VM"
  type        = bool
  default     = false
}

variable "create_from_cloud_image" {
  description = "Создавать ВМ из Cloud Image вместо клонирования"
  type        = bool
  default     = false
}
