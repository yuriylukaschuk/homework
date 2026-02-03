output "template_vm_id" {
  description = "ID созданного шаблона"
  value       = var.template_vm_id
}

output "cloud_image_id" {
  description = "ID загруженного Cloud Image"
  value       = proxmox_virtual_environment_file.cloud_image.id
}
