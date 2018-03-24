output "tor_hostname" {
  value = "${openstack_compute_instance_v2.tor_relay_nodes.*.name}"
}

output "tor_image" {
  value = "${openstack_compute_instance_v2.tor_relay_nodes.*.image_id}"
}

output "tor_keypair" {
  value = "${openstack_compute_instance_v2.tor_relay_nodes.*.key_pair}"
}

output "relay_fip" {
  value = "${openstack_compute_floatingip_associate_v2.tor_relay_assoc_fips.*.floating_ip}"
}
