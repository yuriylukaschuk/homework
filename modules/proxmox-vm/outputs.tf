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

output "template_status" {
  description = "Статус создания шаблона"
  value       = var.create_template ? "Template VM ${var.template_vm_id} created. Convert it to template manually in Proxmox UI when VM stops." : "No template created"
}

output "template_vm_id" {
  description = "ID созданной шаблонной VM"
  value       = var.create_template ? var.template_vm_id : null
}
