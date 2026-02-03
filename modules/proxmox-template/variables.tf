variable "proxmox_node" {
  description = "Имя ноды Proxmox"
  type        = string
  default     = "pve"
}

variable "template_vm_id" {
  description = "ID для шаблонной VM"
  type        = number
  default     = 9000
}

variable "cloud_image_url" {
  description = "URL Cloud Image Ubuntu"
  type        = string
  default     = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

variable "template_disk_size" {
  description = "Размер диска шаблона (в GB)"
  type        = number
  default     = 20
}

variable "template_cores" {
  description = "Количество ядер шаблона"
  type        = number
  default     = 2
}

variable "template_memory" {
  description = "Память шаблона (в MB)"
  type        = number
  default     = 2048
}

variable "storage_pool" {
  description = "Хранилище для шаблона"
  type        = string
  default     = "hdd-thin"
}

variable "snippets_datastore_id" {
  description = "Хранилище для snippets"
  type        = string
  default     = "local"
}

variable "network_bridge" {
  description = "Сетевой мост"
  type        = string
  default     = "vmbr0"
}

# Добавляем переменные для API Proxmox (нужны для конвертации в шаблон)
variable "pm_api_url" {
  description = "URL API Proxmox"
  type        = string
  sensitive   = true
}

variable "pm_api_token_id" {
  description = "ID токена API"
  type        = string
  sensitive   = true
}

variable "pm_api_token_secret" {
  description = "Секрет токена API"
  type        = string
  sensitive   = true
}
