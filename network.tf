############################
#  Create demo VCN  #
############################
# ------ Create demo VCN
resource "oci_core_vcn" "demo" {
  cidr_block     = var.vcn_cidr_block
  dns_label      = var.vcn_dns_label
  compartment_id = var.network_compartment_ocid
  display_name   = var.vcn_display_name
}

################################################
#  Create Loadbalancer Subnet (Public Subnet)  #
################################################
# ------ Create demo VCN IGW
resource "oci_core_internet_gateway" "demo_igw" {
  compartment_id = var.network_compartment_ocid
  display_name   = "${var.vcn_display_name}-igw"
  vcn_id         = oci_core_vcn.demo.id
  enabled        = "true"
}

# ------ Create demo Route Table and Associate to IGW
resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_vcn.demo.default_route_table_id
  display_name               = "Default Route Table for Public Subnets"
  route_rules {
    network_entity_id = oci_core_internet_gateway.demo_igw.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

# ------ Add Load Balancer Subnet to demo VCN
resource "oci_core_subnet" "web_lb-subnet" {
  cidr_block                 = var.web_lb_subnet_cidr_block
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.demo.id
  display_name               = var.web_lb_subnet_display_name
  dns_label                  = var.web_lb_subnet_dns_label
  prohibit_public_ip_on_vnic = false
  security_list_ids          = [data.oci_core_security_lists.allow_all_security_web.security_lists[0].id]
  depends_on = [
    oci_core_security_list.allow_all_security_web,
  ]
}
#################################################
#  Create Security List for Web (Public) Subnet #
#################################################
# ------ Get the Security Lists of Public Subnets in demo VCN
data "oci_core_security_lists" "allow_all_security_web" {
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.demo.id
  filter {
    name   = "display_name"
    values = ["AllowAll"]
  }
  depends_on = [
    oci_core_security_list.allow_all_security_web,
  ]
}


# ------ Update Default Security List to allow Port 443 All Rules
resource "oci_core_security_list" "allow_all_security_web" {
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.demo.id
  display_name   = "AllowAll"
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      source_port_range {
        max = "443"
        min = "443"
      }
    }
  }
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}


# ------ Get the Allow LB Security Lists for Subnets in demo VCN
data "oci_core_security_lists" "allow_vcn_security" {
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.demo.id
  filter {
    name   = "display_name"
    values = ["PrivateSL"]
  }
  depends_on = [
    oci_core_security_list.allow_vcn_security,
  ]
}

########################################################
#  Create Security List for App & DB (Private) Subnets #
########################################################
# ------ Create Security List for App and LB  Subnets
resource "oci_core_security_list" "allow_vcn_security" {
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.demo.id
  display_name   = "PrivateSL"
  ingress_security_rules {
    protocol = "all"
    source   = var.vcn_cidr_block
  }
  egress_security_rules {
    protocol    = "all"
    destination = var.vcn_cidr_block
  }
}

################################################
#  Create Application Subnet (Private Subnet)  #
################################################

# ------ Create demo Route Table and Associate to IGW
resource "oci_core_route_table" "private_route_table" {
  display_name   = "Route Table for Private Subnets"
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.demo.id
}

# ------ Add Load Balancer Subnet to demo VCN
resource "oci_core_subnet" "app-subnet" {
  cidr_block                 = var.app_subnet_cidr_block
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.demo.id
  display_name               = var.app_subnet_display_name
  dns_label                  = var.app_subnet_dns_label
  route_table_id             = oci_core_route_table.private_route_table.id
  prohibit_public_ip_on_vnic = true
  security_list_ids          = [data.oci_core_security_lists.allow_vcn_security.security_lists[0].id]
  depends_on = [
    oci_core_security_list.allow_vcn_security,
  ]
}

#############################################
#  Create Database Subnet (Private Subnet)  #
#############################################
# ------ Add Load Balancer Subnet to demo VCN
resource "oci_core_subnet" "db-subnet" {
  cidr_block                 = var.db_subnet_cidr_block
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.demo.id
  display_name               = var.db_subnet_display_name
  dns_label                  = var.db_subnet_dns_label
  route_table_id             = oci_core_route_table.private_route_table.id
  prohibit_public_ip_on_vnic = true
  security_list_ids          = [data.oci_core_security_lists.allow_vcn_security.security_lists[0].id]
  depends_on = [
    oci_core_security_list.allow_vcn_security,
  ]
}
