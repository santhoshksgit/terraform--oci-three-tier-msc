############################################################
#  Create RSA 256 Key & Policies for Certificate Authority #
############################################################

resource "oci_kms_key" "ca_kms_key" {
    #Required
    count = var.create_private_cert == "true" ? "1" : "0"
    compartment_id = var.compute_compartment_id
    display_name = "ca_key"
    key_shape {
        #Required
        algorithm = "RSA"
        length = "256"
    }
    #management_endpoint = oci_kms_vault.kms_vault.management_endpoint
    management_endpoint = var.management_endpoint
    #depends_on = [oci_identity_policy.ca_kms_policy]
}

# Create Dynamic Group
resource "oci_identity_dynamic_group" "ca_dynamic_group" {
    #Required
    count = var.create_private_cert == "true" ? "1" : "0"
    compartment_id = var.tenancy_id
    description = "ca_dynamic_group"
    matching_rule = "Any {resource.type='certificateauthority'}"
    name = "ca_dynamic_group"

}

data "oci_identity_compartment" "compt_name" {
    #Required
    id = var.compute_compartment_id
}

#Create KMS Policies to be used in Certificate Authority
resource "oci_identity_policy" "ca_kms_policy" {
    #Required
    count = var.create_private_cert == "true" ? "1" : "0"
    compartment_id = var.compute_compartment_id
    description = "Policy_To_Use_In_Certificate_Authority"
    name = "Policy_To_Use_In_Certificate_Authority"
    statements = ["Allow dynamic-group ${oci_identity_dynamic_group.ca_dynamic_group[count.index].name} to use keys in compartment ${data.oci_identity_compartment.compt_name.name}", "Allow dynamic-group ${oci_identity_dynamic_group.ca_dynamic_group[count.index].name} to manage objects in compartment ${data.oci_identity_compartment.compt_name.name}", "Allow group CertificateAuthorityAdmins to manage certificate-authority-family in compartment ${data.oci_identity_compartment.compt_name.name}", "Allow group CertificateAuthorityAdmins to read keys in compartment ${data.oci_identity_compartment.compt_name.name}", "Allow group CertificateAuthorityAdmins to use key-delegate in compartment ${data.oci_identity_compartment.compt_name.name}", "Allow group CertificateAuthorityAdmins to read buckets in compartment ${data.oci_identity_compartment.compt_name.name}", "Allow group CertificateAuthorityAdmins to read vaults in compartment ${data.oci_identity_compartment.compt_name.name}"]
}