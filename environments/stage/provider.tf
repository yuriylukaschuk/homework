
provider "proxmox" {

  # Подключение к Proxmox
  endpoint = var.pm_api_url

  # API Token в формате: TOKEN_ID=SECRET
  api_token = "${var.pm_api_token_id}=${var.pm_api_token_secret}"

  # Для самоподписанных сертификатов
  insecure  = var.pm_tls_insecure

  ssh {
    username    = var.proxmox_ssh_username
    private_key = file(var.proxmox_ssh_private_key_path)
    agent       = false
  }
}
