variable TOR_OS_NETWORK_NAME {}
variable TOR_OS_FLAVOR_NAME {}
variable TOR_OS_IMAGE_NAME {}

variable SSH_PUB_KEY_LOCATION {}
variable TOR_RELAY_NODE_COUNT {}


provider "openstack" {
}


data "openstack_images_image_v2" "image" {
  name        = "${var.TOR_OS_IMAGE_NAME}"
  visibility  = "public"
  most_recent = true
}

data "openstack_networking_network_v2" "public_net" {
  name = "${var.TOR_OS_NETWORK_NAME}"
}


resource "openstack_compute_keypair_v2" "tor_keypair" {
  name       = "vnet-tor-cluster-keypair"
  public_key = "${file(var.SSH_PUB_KEY_LOCATION)}"
}

resource "openstack_compute_secgroup_v2" "ssh_secgroup" {
    name = "allow-ssh-all-ip"
    description = "Allow SSH from all IP addresses"
    rule {
        ip_protocol = "tcp"
        from_port = "22"
        to_port = "22"
        cidr = "0.0.0.0/0"
    }
}

resource "openstack_compute_instance_v2" "tor_relay_nodes" {
  count             = "${var.TOR_RELAY_NODE_COUNT}"
  name              = "${format("vnet-tor-relay-node-%02d", count.index + 1)}"
  image_id          = "${data.openstack_images_image_v2.image.id}"
  flavor_name       = "${var.TOR_OS_FLAVOR_NAME}"
  key_pair          = "${openstack_compute_keypair_v2.tor_keypair.id}"
  security_groups   = ["${openstack_compute_secgroup_v2.ssh_secgroup.name}",
                        "default"
  ]
  network           = {
    name = "${data.openstack_networking_network_v2.public_net.name}"
  }
}

resource "openstack_networking_floatingip_v2" "tor_relay_fips" {
  count = "${var.TOR_RELAY_NODE_COUNT}"
  pool  = "ext-net"
}

resource "openstack_compute_floatingip_associate_v2" "tor_relay_assoc_fips" {
  count = "${var.TOR_RELAY_NODE_COUNT}"
  floating_ip = "${element(openstack_networking_floatingip_v2.tor_relay_fips.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.tor_relay_nodes.*.id, count.index)}"
}
