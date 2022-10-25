###############################################################
#  Create Loadbalancer, Backend, BackendSets in Public Subnet #
###############################################################

resource "oci_load_balancer_load_balancer" "web_lb" {
    #Required
    compartment_id = var.compute_compartment_id
    display_name = var.lb_display_name
    shape = var.load_balancer_shape
    subnet_ids = var.lb_subnets

    #Optional
    ip_mode = "IPV4"
    is_private = var.load_balancer_is_private
    network_security_group_ids = var.network_security_group_ids

    #shape_details {
        #Required
        #maximum_bandwidth_in_mbps = var.lb_max_bandwidth_in_mbps
        #minimum_bandwidth_in_mbps = var.lb_min_bandwidth_in_mbps
    #}
}


resource "oci_load_balancer_backend_set" "web_lb_backend_set" {
    #Required
    health_checker {
        #Required
        protocol = "HTTP"
        url_path = "/"
    }
    ssl_configuration {
        #Optional
        #Validate if we need to create private certificate, or use imported Public Certificate
        trusted_certificate_authority_ids = [var.create_private_cert == "true" ? oci_certificates_management_certificate_authority.certificate_authority[0].id : var.public_import_certificate_id]
    }
    load_balancer_id = oci_load_balancer_load_balancer.web_lb.id
    name = var.backend_set_name
    policy = "ROUND_ROBIN"
}

resource "oci_load_balancer_backend" "web_lb_backend" {
    #Required
    count = var.app_vm_instance_count
    backendset_name = oci_load_balancer_backend_set.web_lb_backend_set.name
    ip_address = var.vm_private_ip[count.index]
    #ip_address = sort(module.app_vm.vm_private_ip)[count.index]
    load_balancer_id = oci_load_balancer_load_balancer.web_lb.id
    port = var.backend_port
}
