terraform {
  # В модуле НЕ указываем версию Terraform
  # Но указываем какие провайдеры он использует
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      # Версию можно не указывать, будет браться из корневого модуля
    }
  }
}
