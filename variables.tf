#Variables declared in this file must be declared in the demo.yaml

############################
#  Hidden Variable Group   #
############################
variable "tenancy_ocid" {
}

variable "region" {
}

variable "network_compartment_ocid" {
  description = "Compartment where Network resources will be created"
}
variable "compute_compartment_ocid" {
  description = "Compartment where Comopute resources will be created"
}

variable "vcn_display_name" {
  description = "demo VCN Display Name"
  default     = "demo-vcn"
}
variable "vcn_dns_label" {
  description = "demo VCN DNS Label"
  default     = "demo"
}

variable "vcn_cidr_block" {
  description = "demo VCN CIDR Block"
  default     = "10.100.0.0/16"
}

variable "web_lb_subnet_cidr_block" {
  description = "Web Spoke VCN Loadbalancer Subnet"
  default     = "10.100.1.0/24"
}

variable "web_lb_subnet_display_name" {
  description = "Web LB Subnet Display Name"
  default     = "web_lb-subnet"
}

variable "web_lb_subnet_dns_label" {
  description = "Web LB DNS Label"
  default     = "weblb"
}


variable "app_subnet_cidr_block" {
  description = "Application Subnet CIDR"
  default     = "10.100.2.0/24"
}


variable "app_subnet_display_name" {
  description = "Application Subnet Display Name"
  default     = "app-subnet"
}

variable "app_subnet_dns_label" {
  description = "Application DNS Label"
  default     = "app"
}

variable "db_subnet_cidr_block" {
  description = "Database Subnet CIDR"
  default     = "10.100.3.0/24"
}

variable "db_subnet_display_name" {
  description = "Database Subnet Display Name"
  default     = "db-subnet"
}

variable "db_subnet_dns_label" {
  description = "Database DNS Label"
  default     = "db"
}

variable "bastion_host_allow_cidr" {
  description = "Bastion Host Allow CIDR"
}

variable "lb_nsg_display_name" {
  description = "Loadbalancer Display Name"
  default     = "LB_NSG"
}

variable "lb_nsg_rules" {
  type = map(
    object(
      {
        protocol         = number
        source_cidr      = string
        source_type      = string
        destination_port = string
      }
    )
  )
}

variable "availability_domain_number" {
  description = "Availability Domain Number for App & DB"
  default     = "1"
}

variable "app_vm_instance_count" {
  description = "Application VM Instance Counnt"
  default     = "2"
}
variable "app_vm_display_name" {
  description = "Application VM Display Name"
  default     = "app-vm"
}

variable "app_vm_shape" {
  description = "Application VM Compute Shape"
}

variable "app_vm_memory_in_gbs" {
  description = "Application VM Memory in GBs"
}

variable "app_vm_ocpus" {
  description = "Application VM Compute in OCPUs"
}

variable "app_vm_boot_volume_size" {
  description = "Application VM boot volume size in GBs"
}

variable "ssh_public_key" {
  description = "SSH Public Key String"
}

variable "app_nsg_display_name" {
  description = "Application NSG Display Name"
  default     = "APP_NSG"
}

variable "app_nsg_rules" {
  type = map(
    object(
      {
        protocol         = number
        source_cidr      = string
        source_type      = string
        destination_port = string
      }
    )
  )
  default = {}
}


variable "db_vm_instance_count" {
  description = "Database VM Instance Counnt"
  default     = "1"
}
variable "db_vm_display_name" {
  description = "Database VM Display Name"
  default     = "db-vm"
}

variable "db_vm_shape" {
  description = "Database VM Compute Shape"
}

variable "db_vm_memory_in_gbs" {
  description = "Database VM Memory in GBs"
}

variable "db_vm_ocpus" {
  description = "Database VM Compute in OCPUs"
}

variable "db_vm_boot_volume_size" {
  description = "Database VM boot volume size in GBs"
}

variable "db_nsg_display_name" {
  description = "Database NSG Display Name"
  default     = "DB_NSG"
}

variable "db_nsg_rules" {
  type = map(
    object(
      {
        protocol         = number
        source_cidr      = string
        source_type      = string
        destination_port = string
      }
    )
  )
  default = {}
}

variable "vault_display_name" {
  description = "OCI Vault Display Name"
  default     = "demo_vault"
}

variable "vault_type" {
  description = "OCI Vault Type"
}

variable "kms_key_display_name" {
  description = "KMS Master Encryption Key Display Name"
}

variable "lb_display_name" {
  description = "Web Load Balancer Display Name"
}

variable "load_balancer_shape" {
  description = "Load Balancer Shape"
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

variable "create_private_cert" {
  description = "Do you want to create Private SSL Certificate?"
}

variable "public_import_certificate_id" {
  description = "Imported Public Certificate OCID"
}

variable "ca_common_name" {
  description = "Common Domain Name for Certificate Authority"
  default     = "demo.com"
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
