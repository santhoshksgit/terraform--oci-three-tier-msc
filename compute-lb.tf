##########################################
#  Create Bastion Host in Public Subnet  #
##########################################

resource "oci_bastion_bastion" "oci_bastion" {
  bastion_type                 = "STANDARD"
  compartment_id               = var.compute_compartment_ocid
  target_subnet_id             = oci_core_subnet.web_lb-subnet.id
  client_cidr_block_allow_list = [var.bastion_host_allow_cidr]
}

###########################################
#  Create Load Balancer in Public Subnet  #
###########################################
module "web_lb" {
  depends_on                 = [oci_core_network_security_group.lb_nsg]
  compute_compartment_id     = var.compute_compartment_ocid
  tenancy_id                 = var.tenancy_ocid
  source                     = "./modules/load-balancer"
  lb_display_name            = var.lb_display_name
  lb_subnets                 = [oci_core_subnet.web_lb-subnet.id]
  network_security_group_ids = [oci_core_network_security_group.lb_nsg.id]
  load_balancer_is_private   = var.load_balancer_is_private
  load_balancer_shape        = var.load_balancer_shape
  #lb_max_bandwidth_in_mbps = var.lb_max_bandwidth_in_mbps
  #lb_min_bandwidth_in_mbps = var.lb_min_bandwidth_in_mbps
  backend_set_name             = var.backend_set_name
  backend_port                 = var.backend_port
  app_vm_instance_count        = var.app_vm_instance_count
  vm_private_ip                = sort(module.app_vm.vm_private_ip)[*]
  management_endpoint          = oci_kms_vault.kms_vault.management_endpoint
  create_private_cert          = var.create_private_cert
  ca_common_name               = var.ca_common_name
  public_import_certificate_id = var.public_import_certificate_id
  #cert_chain_pem = var.cert_chain_pem
  #certificate_pem = var.certificate_pem
  #private_key_pem = var.private_key_pem
  #private_key_pem_passphrase = var.private_key_pem_passphrase
}

########################################################################
#  Create Application Instance in Private App Subnet & Bastion Session #
########################################################################

module "app_vm" {
  depends_on                 = [oci_core_network_security_group.app_nsg]
  source                     = "./modules/compute"
  instance_count             = var.app_vm_instance_count
  availability_domain_number = var.availability_domain_number
  compartment_id             = var.compute_compartment_ocid
  display_name               = var.app_vm_display_name
  shape                      = var.app_vm_shape
  tenancy_ocid               = var.tenancy_ocid
  nsg_id                     = [oci_core_network_security_group.app_nsg.id]
  kms_key_id                 = oci_kms_key.kms_key.id

  // If shape name contains ".Flex" and instance_flex inputs are not null, use instance_flex inputs values for shape_config block
  // Else use values from data.oci_core_shapes.current_ad for var.shape
  memory_in_gbs = local.app_vm_shape_is_flex == true && var.app_vm_memory_in_gbs != null ? var.app_vm_memory_in_gbs : local.shapes_config[var.app_vm_shape]["memory_in_gbs"]
  ocpus         = local.app_vm_shape_is_flex == true && var.app_vm_ocpus != null ? var.app_vm_ocpus : local.shapes_config[var.app_vm_shape]["ocpus"]

  subnet_id               = oci_core_subnet.app-subnet.id
  boot_volume_size_in_gbs = var.app_vm_boot_volume_size
  ssh_authorized_keys     = var.ssh_public_key
  bastion_id              = oci_bastion_bastion.oci_bastion.id
}

####################################################################
#  Create Database Instance in Private DB Subnet & Bastion Session #
####################################################################

module "db_vm" {
  depends_on                 = [oci_core_network_security_group.db_nsg]
  source                     = "./modules/compute"
  instance_count             = var.db_vm_instance_count
  availability_domain_number = var.availability_domain_number
  compartment_id             = var.compute_compartment_ocid
  display_name               = var.db_vm_display_name
  shape                      = var.db_vm_shape
  tenancy_ocid               = var.tenancy_ocid
  nsg_id                     = [oci_core_network_security_group.db_nsg.id]
  kms_key_id                 = oci_kms_key.kms_key.id

  // If shape name contains ".Flex" and instance_flex inputs are not null, use instance_flex inputs values for shape_config block
  // Else use values from data.oci_core_shapes.current_ad for var.shape
  memory_in_gbs = local.db_vm_shape_is_flex == true && var.db_vm_memory_in_gbs != null ? var.db_vm_memory_in_gbs : local.shapes_config[var.db_vm_shape]["memory_in_gbs"]
  ocpus         = local.db_vm_shape_is_flex == true && var.db_vm_ocpus != null ? var.db_vm_ocpus : local.shapes_config[var.db_vm_shape]["ocpus"]

  subnet_id               = oci_core_subnet.db-subnet.id
  boot_volume_size_in_gbs = var.db_vm_boot_volume_size
  ssh_authorized_keys     = var.ssh_public_key
  bastion_id              = oci_bastion_bastion.oci_bastion.id
}
