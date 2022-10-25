user_ocid                = "ocid1.user.oc1.."
fingerprint              = ""
network_compartment_ocid = "ocid1.compartment.oc1.."
private_key_path         = "~/.oci/oci_api_key.pem"
tenancy_ocid             = "ocid1.tenancy.oc1.."
region                   = "ap-mumbai-1"
ssh_public_key           = "ssh-rsa.."

vcn_cidr_block           = "10.200.0.0/16"
web_lb_subnet_cidr_block = "10.200.1.0/24"
app_subnet_cidr_block    = "10.200.2.0/24"
db_subnet_cidr_block     = "10.200.3.0/24"
bastion_host_allow_cidr  = "0.0.0.0/0"

vault_type           = "DEFAULT" // recommended to use VIRTUAL_PRIVATE for Production
kms_key_display_name = "master_key"

// Addtional NSG Rules for LB, add rule_2, rule_3, etc.,
lb_nsg_rules = {
  "rule_1" = {
    protocol         = 6
    source_cidr      = "0.0.0.0/0"
    source_type      = "CIDR_BLOCK"
    destination_port = "443"
  }
}

compute_compartment_ocid = "ocid1.compartment.oc1..aaaaaaaazyq7yf2w5yfoq3pbtexehnda3cdmlgkzldbxjlsuuvu66vat5kxa"
app_vm_instance_count    = "1"
app_vm_shape             = "VM.Standard.E3.Flex"
app_vm_memory_in_gbs     = "8"
app_vm_ocpus             = "1"
app_vm_boot_volume_size  = "50"

// Addtional NSG Rules for APP VM, add rule_2, rule_3, etc.,
app_nsg_rules = {
  "rule_1" = {
    protocol         = 6
    source_cidr      = "10.0.0.0/8"
    source_type      = "CIDR_BLOCK"
    destination_port = "22"
  }
}

db_vm_instance_count   = "1"
db_vm_shape            = "VM.Standard.E3.Flex"
db_vm_memory_in_gbs    = "8"
db_vm_ocpus            = "1"
db_vm_boot_volume_size = "50"

// Addtional NSG Rules for APP VM, add rule_2, rule_3, etc.,
db_nsg_rules = {
  "rule_1" = {
    protocol         = 6
    source_cidr      = "10.0.0.0/8"
    source_type      = "CIDR_BLOCK"
    destination_port = "22"
  }
}

create_private_cert      = "true"
lb_display_name          = "web-lb"
load_balancer_shape      = "100Mbps"
load_balancer_is_private = "false"
#lb_max_bandwidth_in_mbps = "10"
#lb_min_bandwidth_in_mbps = "10"
backend_set_name             = "backendset"
backend_port                 = "80"
public_import_certificate_id = ""
