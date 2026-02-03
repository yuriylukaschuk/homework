output "vm_ids" {
  description = "ID созданных виртуальных машин"
  value = {
    for vm_name, vm in proxmox_virtual_environment_vm.virtual_machines :
    vm_name => vm.vm_id
  }
}

output "vm_ip_addresses" {
  description = "IP адреса созданных виртуальных машин"
  value = {
    for vm_name, vm in proxmox_virtual_environment_vm.virtual_machines :
    vm_name => vm.ipv4_addresses
  }
  sensitive = true
}

output "cloud_init_file_ids" {
  description = "ID файлов cloud-init"
  value = {
    for vm_name, file in proxmox_virtual_environment_file.cloud_init :
    vm_name => file.id
  }
}
