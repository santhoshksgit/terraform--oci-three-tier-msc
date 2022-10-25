// Get all the Availability Domains for the region and default backup policies
data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.availability_domain_number
}

# ------ Get the Tenancy ID and ADs
data "oci_identity_availability_domains" "ads" {
  #Required
  compartment_id = var.tenancy_ocid
}

locals {
  ADs = [
    // Iterate through data.oci_identity_availability_domains.ad and create a list containing AD names
    for i in data.oci_identity_availability_domains.ads.availability_domains : i.name
  ]
}
####################################
#  Get the Faulte Domain within AD #
####################################
# ------ Get the Faulte Domain within AD 
data "oci_identity_fault_domains" "fds" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_id

  depends_on = [
    data.oci_identity_availability_domain.ad,
  ]
}

#########################################
### Get the latest Oracle Linux image ###
#########################################
data "oci_core_images" "InstanceImageOCID" {
  compartment_id = var.compartment_id
  shape = var.shape

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}