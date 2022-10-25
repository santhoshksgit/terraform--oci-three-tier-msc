#######################################################
#  Create Key Vault & MEK for Block Volume Encryption #
#######################################################

resource "oci_kms_vault" "kms_vault" {
  #Required
  compartment_id = var.compute_compartment_ocid
  display_name   = var.vault_display_name
  vault_type     = var.vault_type
}

resource "oci_kms_key" "kms_key" {
  #Required
  compartment_id = var.compute_compartment_ocid
  display_name   = var.kms_key_display_name
  key_shape {
    #Required
    algorithm = "AES"
    length    = "24"
  }
  management_endpoint = oci_kms_vault.kms_vault.management_endpoint
  depends_on          = [oci_identity_policy.kms_policy]
}

data "oci_identity_compartment" "compartment_name" {
  #Required
  id = var.compute_compartment_ocid
}

resource "oci_identity_policy" "kms_policy" {
  #Required
  compartment_id = var.compute_compartment_ocid
  description    = "Policy_To_Enable_Encrypting_Block_Volumes"
  name           = "Policy_To_Enable_Encrypting_Block_Volumes"
  statements     = ["Allow service blockstorage to use keys in compartment ${data.oci_identity_compartment.compartment_name.name}"]
}
