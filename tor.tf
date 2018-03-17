variable TOR_OS_NETWORK_NAME {}
variable TOR_OS_FLAVOR_NAME {}
variable TOR_OS_IMAGE_NAME {}

variable SSH_PUB_KEY_LOCATION {}
variable SSH_PRIV_KEY_LOCATION {}
variable TOR_RELAY_NODE_COUNT {}

variable ANSIBLE_RELAYOR_PLAYBOOK_PATH {}
variable ANSIBLE_PLAYBOOK_USER {}

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
resource "openstack_compute_secgroup_v2" "tor_or_1_secgroup" {
    name = "allow-tor-or-1-all"
    description = "Allow OR port 1"
    rule {
        ip_protocol = "tcp"
        from_port = "9000"
        to_port = "9000"
        cidr = "0.0.0.0/0"
    }
}
resource "openstack_compute_secgroup_v2" "tor_or_2_secgroup" {
    name = "allow-tor-or-2-all"
    description = "Allow OR port 2 "
    rule {
        ip_protocol = "tcp"
        from_port = "9100"
        to_port = "9100"
        cidr = "0.0.0.0/0"
    }
}
resource "openstack_compute_secgroup_v2" "tor_dir_1_secgroup" {
    name = "allow-tor-dir-1-all"
    description = "Allow Dir port 1 "
    rule {
        ip_protocol = "tcp"
        from_port = "9001"
        to_port = "9001"
        cidr = "0.0.0.0/0"
    }
}
resource "openstack_compute_secgroup_v2" "tor_dir_2_secgroup" {
    name = "allow-tor-dir-2-all"
    description = "Allow Dir port 2 "
    rule {
        ip_protocol = "tcp"
        from_port = "9101"
        to_port = "9101"
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
                       "${openstack_compute_secgroup_v2.tor_or_1_secgroup.name}",
                       "${openstack_compute_secgroup_v2.tor_or_2_secgroup.name}",
                       "${openstack_compute_secgroup_v2.tor_dir_1_secgroup.name}",
                       "${openstack_compute_secgroup_v2.tor_dir_2_secgroup.name}",
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
  count       = "${var.TOR_RELAY_NODE_COUNT}"
  floating_ip = "${element(openstack_networking_floatingip_v2.tor_relay_fips.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.tor_relay_nodes.*.id, count.index)}"

  provisioner "local-exec" {
    command    = "echo '${element(openstack_networking_floatingip_v2.tor_relay_fips.*.address, count.index)}' >> ansible_inventory"
    on_failure = "fail"
  }

  provisioner "local-exec" {
    command = "sleep 200; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.ANSIBLE_PLAYBOOK_USER} --private-key ${var.SSH_PRIV_KEY_LOCATION} -i '${element(openstack_networking_floatingip_v2.tor_relay_fips.*.address, count.index)},' ${var.ANSIBLE_RELAYOR_PLAYBOOK_PATH}"
  }
}
