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

variable "timeout" {
  description = "ID шаблона ВМ для клонирования"
  type        = number
  default     = 600
}

# Дополнительные настройки модуля
variable "autostart_vms" {
  description = "Автоматически запускать VM после создания"
  type        = bool
  default     = true
}

variable "additional_cloud_config" {
  description = "Дополнительная конфигурация cloud-init"
  type        = string
  default     = ""
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
  description = "Хранилище для ВМ"
  type        = string
  default     = "hdd-thin"
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
  default     = "vmbr0"
}

variable "network_cidr" {
  description = "CIDR внутренней сети"
  type        = string
  default     = "10.10.10.0/24"
}

variable "gateway" {
  description = "Шлюз по умолчанию"
  type        = string
  default     = "10.10.10.1"
}

variable "dns_servers" {
  description = "DNS серверы для ВМ"
  type        = list(string)
  default     = ["8.8.8.8", "1.1.1.1"]
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
    vmid       = number
    cores      = number
    memory     = number
    disk_size  = number
    ip_address = string
  }))
  default = {
    "vm-1" = {
      vmid       = 110
      cores      = 1
      memory     = 1024
      disk_size  = 20
      ip_address = "10.10.10.110"
    }
    "vm-2" = {
      vmid       = 111
      cores      = 1
      memory     = 1024
      disk_size  = 20
      ip_address = "10.10.10.111"
    }
    "vm-3" = {
      vmid       = 112
      cores      = 1
      memory     = 1024
      disk_size  = 20
      ip_address = "10.10.10.112"
    }
  }
}

variable "cloud_image_url" {
  description = "URL Cloud Image для создания шаблона"
  type        = string
  default     = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

variable "timezone" {
  description = "Часовой пояс для ВМ"
  type        = string
  default     = "Europe/Moscow"
}

