terraform {
  required_version = ">= 1.14.4"

	required_providers {
		proxmox = {
			source  = "bpg/proxmox"
			version = "0.93.1"
		}
		null = {
			source = "hashicorp/null"
			version = "~> 3.2"
		}
	}
}
