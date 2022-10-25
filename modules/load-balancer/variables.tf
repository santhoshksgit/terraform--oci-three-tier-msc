variable "management_endpoint" {
    description = "Vault Management Endpoint"
}

variable "lb_subnets" {
  description = "Subnets for Web Load Balancer"
}

variable "lb_display_name" {
  description = "Web Load Balancer Display Name"
}

variable "network_security_group_ids" {
  description = "Web Load Balancer NSG IDs"
}

variable "load_balancer_shape" {
  description = "Load Balancer Shape"
}

variable "tenancy_id" {
  description = "Tenancy id to create Dynamic Group"
}

variable "compute_compartment_id" {
  description = "Compartment where Compute resources"
}

variable "load_balancer_is_private" {
  description = "Load Balancer is Private or Public"
}

#variable "lb_max_bandwidth_in_mbps" {
#  description = "LB Maximum Bandwidth in mbps"
#}

#variable "lb_min_bandwidth_in_mbps" {
#  description = "LB Minimum Bandwidth in mbps"
#}

variable "backend_set_name" {
  description = "LB BackendSet Display Name"
}

variable "backend_port" {
  description = "LB Backend Port"
}

variable "app_vm_instance_count" {
  description = "Application VM Instance Counnt"
}

variable "vm_private_ip" {
    description = "VM Private IP Addressess"
}

variable "create_private_cert" {
  description = "Do you want to create Private SSL Certificate?"
}

#variable "ssl_public_cert" {
#  description = "Enter SSL Public Certificate"
#}

variable "ca_common_name" {
  description = "Common Domain Name for Certificate Authority"
  default = "demo.com"
}

variable "public_import_certificate_id" {
    description = "Imported Public Certificate OCID"
}

### -- config_type = "IMPORTED" is not supported in terraform at this moment -- ###
/*
variable "cert_chain_pem" {
  description = "Enter Public Certificate Chain in .pem format"
  default = ""
}

variable "certificate_pem" {
  description = "Enter Public Certificate in .pem format"
  default = ""
}

variable "private_key_pem" {
  description = "Enter Private Key"
  default = ""
}

variable "private_key_pem_passphrase" {
  description = "Enter Private Key passphrase"
  default = ""
}
*/

