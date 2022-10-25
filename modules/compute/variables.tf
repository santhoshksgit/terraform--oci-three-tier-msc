variable "availability_domain_number" {
  description = "Availability Domain Number for VM"
}
variable "tenancy_ocid" {
  description = "tenancy OCID"
}

variable "compartment_id" {
  description = "Compartment where the resources will be created"
}

variable "kms_key_id" {
  description = "KMS Key ID for Block Volume Encryption"
}

variable "display_name" {
  description = "VM Display Name"
}

variable "instance_count" {
  description = "VM Instance Count"
}

variable "shape" {
  description = "VM Compute Shape"
}

variable "memory_in_gbs" {
  description = "VM Memory in GBs"
}

variable "ocpus" {
  description = "VM Compute in OCPUs"
}

variable "nsg_id" {
  description = "NSG IDs for the VM"
}

variable "boot_volume_size_in_gbs" {
  description = "VM boot volume size in GBs"
}

variable "ssh_authorized_keys" {
  description = "SSH Public Key String"
}

variable "subnet_id" {
  description = "Subnet ID for VM"
}
variable "bastion_id" {
  description = "Bastion ID"
}