################################
#  VM Instances based on count #
################################
resource "oci_core_instance" "vms" {
  count = var.instance_count

  // If no explicit AD number, spread instances on all ADs in round-robin. Looping to the first when last AD is reached
  availability_domain = var.availability_domain_number == null ? element(local.ADs, count.index) : element(local.ADs, var.availability_domain_number - 1)
  compartment_id      = var.compartment_id
  display_name        = "${var.display_name}-${count.index + 1}"
  shape               = var.shape
  fault_domain        = data.oci_identity_fault_domains.fds.fault_domains[count.index].name

  shape_config {
    memory_in_gbs             = var.memory_in_gbs
    ocpus                     = var.ocpus
  }

  agent_config {

    #Optional
    plugins_config {
        #Required
        desired_state = "ENABLED"
        name = "Bastion"
    }
  }

  create_vnic_details {
    subnet_id              = var.subnet_id
    display_name           = var.display_name
    assign_public_ip       = false
    nsg_ids     = var.nsg_id
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.InstanceImageOCID.images[1].id
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
    kms_key_id  = var.kms_key_id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
  }
}
############################################
#  Create Bastion host Session for each VM #
############################################
resource "oci_bastion_session" "vm_session" {
  bastion_id = var.bastion_id
  key_details {
    public_key_content = var.ssh_authorized_keys
  }
  target_resource_details {
    session_type       = "PORT_FORWARDING"
    target_resource_id = oci_core_instance.vms.0.id
    #target_resource_operating_system_user_name = "user1"
  }
  display_name = var.display_name
  depends_on   = [oci_core_instance.vms]
}