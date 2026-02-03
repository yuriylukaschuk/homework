# Задайте нужную версию
PROVIDER_VERSION="3.0.2-rc07"
PROVIDER_NAME="telmate"
PROVIDER_TYPE="proxmox"

# Создайте целевую директорию в вашей структуре
sudo mkdir -p "/opt/terraform/providers/registry.terraform.io/${PROVIDER_NAME}/${PROVIDER_TYPE}/${PROVIDER_VERSION}/linux_amd64"

# Перейдите в неё и скачайте релиз
cd "/opt/terraform/providers/registry.terraform.io/${PROVIDER_NAME}/${PROVIDER_TYPE}/${PROVIDER_VERSION}/linux_amd64"
sudo wget "https://github.com/Telmate/terraform-provider-proxmox/releases/download/v${PROVIDER_VERSION}/terraform-provider-proxmox_${PROVIDER_VERSION}_linux_amd64.zip"
sudo unzip "terraform-provider-proxmox_${PROVIDER_VERSION}_linux_amd64.zip"
sudo rm "terraform-provider-proxmox_${PROVIDER_VERSION}_linux_amd64.zip"

# Установите правильные права для всех пользователей
sudo chmod -R 755 /opt/terraform/providers
