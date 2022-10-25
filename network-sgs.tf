
#################################
# Create NSG for Load Balancer  #
#################################

resource "oci_core_network_security_group" "lb_nsg" {
  #Required
  compartment_id = var.compute_compartment_ocid
  vcn_id         = oci_core_vcn.marketplace.id

  #Optional
  display_name = var.lb_nsg_display_name
}


# Create NSG Ingress rules to LB NSG #
resource "oci_core_network_security_group_security_rule" "lb_nsg_rules_ingress" {
  for_each = var.lb_nsg_rules
  #Required
  network_security_group_id = oci_core_network_security_group.lb_nsg.id
  direction                 = "INGRESS"
  protocol                  = each.value["protocol"]

  source      = each.value["source_cidr"]
  source_type = each.value["source_type"]
  tcp_options {

    #Optional
    destination_port_range {
      #Required
      max = each.value["destination_port"]
      min = each.value["destination_port"]
    }
  }
}

# Create NSG Egress rules from LB to Internet NSG - Open to all traffic #
resource "oci_core_network_security_group_security_rule" "lb_to_out_nsg_rules_egress" {

    network_security_group_id = oci_core_network_security_group.lb_nsg.id
    direction = "EGRESS"
    protocol = "all"
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
}

##################################
# Create NSG for Application VM  #
##################################

resource "oci_core_network_security_group" "app_nsg" {
  #Required
  compartment_id = var.compute_compartment_ocid
  vcn_id         = oci_core_vcn.marketplace.id

  #Optional
  display_name = var.app_nsg_display_name
}

# Create NSG rules from LB NSG to Application VM NSG #
resource "oci_core_network_security_group_security_rule" "lb_to_app_rules_ingress" {
  #Required
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                 = "INGRESS"
  protocol                  = 6
  source                    = oci_core_network_security_group.lb_nsg.id
  source_type               = "NETWORK_SECURITY_GROUP"
  tcp_options {
    #Optional
    destination_port_range {
      #Required
      max = "443"
      min = "443"
    }
  }
}

# Create Additional NSG rules for Application VM  #
resource "oci_core_network_security_group_security_rule" "app_nsg_rules_ingress" {
  for_each = var.app_nsg_rules
  #Required
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                 = "INGRESS"
  protocol                  = each.value["protocol"]
  source                    = each.value["source_cidr"]
  source_type               = each.value["source_type"]
  tcp_options {

    #Optional
    destination_port_range {
      #Required
      max = each.value["destination_port"]
      min = each.value["destination_port"]
    }
  }
}

# Create NSG Egress rules to Application to LB NSG - Open to all traffic #
resource "oci_core_network_security_group_security_rule" "app_to_lb_nsg_rules_egress" {
    network_security_group_id = oci_core_network_security_group.app_nsg.id
    direction = "EGRESS"
    protocol = "all"
    destination = oci_core_network_security_group.lb_nsg.id
    destination_type = "NETWORK_SECURITY_GROUP"
}


##################################
# Create NSG for Database VM  #
##################################

resource "oci_core_network_security_group" "db_nsg" {
  #Required
  compartment_id = var.compute_compartment_ocid
  vcn_id         = oci_core_vcn.marketplace.id

  #Optional
  display_name = var.db_nsg_display_name
}

# Create NSG rules from Application NSG to Database VM NSG #
resource "oci_core_network_security_group_security_rule" "app_to_db_rules_ingress" {
  #Required
  network_security_group_id = oci_core_network_security_group.db_nsg.id
  direction                 = "INGRESS"
  protocol                  = 6
  source                    = oci_core_network_security_group.app_nsg.id
  source_type               = "NETWORK_SECURITY_GROUP"
  tcp_options {
    #Optional
    destination_port_range {
      #Required
      max = "5432"
      min = "5432"
    }
  }
}

# Create Additional NSG rules for Database VM  #
resource "oci_core_network_security_group_security_rule" "db_nsg_rules_ingress" {
  for_each = var.db_nsg_rules
  #Required
  network_security_group_id = oci_core_network_security_group.db_nsg.id
  direction                 = "INGRESS"
  protocol                  = each.value["protocol"]
  source                    = each.value["source_cidr"]
  source_type               = each.value["source_type"]
  tcp_options {

    #Optional
    destination_port_range {
      #Required
      max = each.value["destination_port"]
      min = each.value["destination_port"]
    }
  }
}
# Create NSG Egress rules Database to Application NSG - Open Egress all traffic #
resource "oci_core_network_security_group_security_rule" "db_nsg_rules_egress" {
    network_security_group_id = oci_core_network_security_group.db_nsg.id
    direction = "EGRESS"
    protocol = "all"
    destination = oci_core_network_security_group.app_nsg.id
    destination_type = "NETWORK_SECURITY_GROUP"
}