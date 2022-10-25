#######################################################
#  Create Certificate Authority & Interal Certificate #
#######################################################

# Create root Certificate Authority
resource "oci_certificates_management_certificate_authority" "certificate_authority" {
    #Required
    count = var.create_private_cert == "true" ? "1" : "0"    
    certificate_authority_config {
        #Required
        config_type = "ROOT_CA_GENERATED_INTERNALLY"
        subject {
            #Optional
            common_name = var.ca_common_name
        }
    }
    compartment_id = var.compute_compartment_id
    kms_key_id = oci_kms_key.ca_kms_key[count.index].id
    name = var.ca_common_name
}

# Create Private Certificate - to be used only for non-prod
resource "oci_certificates_management_certificate" "local_certificate" {
    #Required
    count = var.create_private_cert == "true" ? "1" : "0"    
    certificate_config {
        #Required
        config_type = "ISSUED_BY_INTERNAL_CA"

        certificate_profile_type = "TLS_SERVER_OR_CLIENT"
        issuer_certificate_authority_id = oci_certificates_management_certificate_authority.certificate_authority[count.index].id
        signature_algorithm = "SHA256_WITH_RSA"
        subject {
            common_name = var.ca_common_name
        }
    }
    compartment_id = var.compute_compartment_id
    name = var.ca_common_name
}
/*
### -- config_type = "IMPORTED" is not supported in terraform at this moment -- ###
# Import Public Certificate - To be used for Production
resource "oci_certificates_management_certificate" "public_import_certificate" {
    #Required
    count = var.create_private_cert == "false" ? "1" : "0"   
    name = var.ca_common_name 
    certificate_config {
        #Required
        config_type = "IMPORTED"

        #Optional
        cert_chain_pem = var.cert_chain_pem
        certificate_pem = var.certificate_pem
        private_key_pem = var.private_key_pem
        private_key_pem_passphrase = var.private_key_pem_passphrase
    }
    compartment_id = var.compute_compartment_id
}
*/