output "tor_hostname" {
  value = "${openstack_compute_instance_v2.tor_nodes.*.name}"
}

output "tor_image" {
  value = "${openstack_compute_instance_v2.tor_nodes.*.image_id}"
}

output "tor_keypair" {
  value = "${openstack_compute_instance_v2.tor_nodes.*.key_pair}"
}

output "tor_node_fip" {
  value = "${openstack_compute_floatingip_associate_v2.tor_assoc_fips.*.floating_ip}"
}
