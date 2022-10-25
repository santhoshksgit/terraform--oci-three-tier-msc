
############
# Shapes
############

// Create a data source for compute shapes.
// Filter on current AD to remove duplicates and give all the shapes supported on the AD.
// This will not check quota and limits for AD requested at resource creation
data "oci_core_shapes" "current_ad" {
  compartment_id = var.compute_compartment_ocid
  #availability_domain = var.availability_domain_number == null ? element(local.ADs, 0) : element(local.ADs, var.availability_domain_number - 1)
}

locals {
  shapes_config = {
    // prepare data with default values for flex shapes. Used to populate shape_config block with default values
    // Iterate through data.oci_core_shapes.current_ad.shapes (this exclude duplicate data in multi-ad regions) and create a map { name = { memory_in_gbs = "xx"; ocpus = "xx" } }
    for i in data.oci_core_shapes.current_ad.shapes : i.name => {
      "memory_in_gbs" = i.memory_in_gbs
      "ocpus"         = i.ocpus
    }
  }
  app_vm_shape_is_flex = length(regexall("^*.Flex", var.app_vm_shape)) > 0 # evaluates to boolean true when var.app_vm_shape contains .Flex
  db_vm_shape_is_flex  = length(regexall("^*.Flex", var.db_vm_shape)) > 0  # evaluates to boolean true when var.db_vm_shape contains .Flex  

}