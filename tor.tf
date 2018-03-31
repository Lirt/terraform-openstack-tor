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
  name       = "${var.TOR_OS_KEYPAIR_NAME}"
  public_key = "${file(var.SSH_PUB_KEY_LOCATION)}"
}

resource "openstack_compute_secgroup_v2" "ssh_secgroup" {
    name = "tor-allow-ssh-all-ip"
    description = "Allow SSH from all IP addresses"
    rule {
        ip_protocol = "tcp"
        from_port = "22"
        to_port = "22"
        cidr = "0.0.0.0/0"
    }
}
resource "openstack_compute_secgroup_v2" "tor_or_1_secgroup" {
    name = "tor-allow-or-1-all"
    description = "Allow Tor OR port 1"
    rule {
        ip_protocol = "tcp"
        from_port = "9000"
        to_port = "9000"
        cidr = "0.0.0.0/0"
    }
}
resource "openstack_compute_secgroup_v2" "tor_or_2_secgroup" {
    name = "tor-allow-or-2-all"
    description = "Allow Tor OR port 2 "
    rule {
        ip_protocol = "tcp"
        from_port = "9100"
        to_port = "9100"
        cidr = "0.0.0.0/0"
    }
}
resource "openstack_compute_secgroup_v2" "tor_dir_1_secgroup" {
    name = "tor-allow-dir-1-all"
    description = "Allow Tor Directory port 1 "
    rule {
        ip_protocol = "tcp"
        from_port = "9001"
        to_port = "9001"
        cidr = "0.0.0.0/0"
    }
}
resource "openstack_compute_secgroup_v2" "tor_dir_2_secgroup" {
    name = "tor-allow-dir-2-all"
    description = "Allow Tor Directory port 2 "
    rule {
        ip_protocol = "tcp"
        from_port = "9101"
        to_port = "9101"
        cidr = "0.0.0.0/0"
    }
}


resource "openstack_compute_instance_v2" "tor_relay_nodes" {
  count             = "${var.TOR_RELAY_NODE_COUNT}"
  name              = "${format("${var.TOR_RELAY_NICKNAME}-%02d", count.index + 1)}"
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

resource "openstack_compute_instance_v2" "tor_exit_nodes" {
  count             = "${var.TOR_EXIT_NODE_COUNT}"
  name              = "${format("${var.TOR_EXIT_NICKNAME}-%02d", count.index + 1)}"
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
  pool  = "${var.TOR_OS_EXT_NET_POOL}"
}

resource "openstack_networking_floatingip_v2" "tor_exit_fips" {
  count = "${var.TOR_EXIT_NODE_COUNT}"
  pool  = "${var.TOR_OS_EXT_NET_POOL}"
}

resource "openstack_compute_floatingip_associate_v2" "tor_relay_assoc_fips" {
  count       = "${var.TOR_RELAY_NODE_COUNT}"
  floating_ip = "${element(openstack_networking_floatingip_v2.tor_relay_fips.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.tor_relay_nodes.*.id, count.index)}"

  provisioner "local-exec" {
    environment {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
    command = <<EOF
                sleep 200; \
                ansible-playbook \
                  --user ${var.ANSIBLE_PLAYBOOK_USER} \
                  --private-key ${var.SSH_PRIV_KEY_LOCATION} \
                  --inventory '${element(openstack_networking_floatingip_v2.tor_relay_fips.*.address, count.index)},' \
                  ${var.ANSIBLE_RELAYOR_RELAY_PLAYBOOK_PATH}
               EOF
  }
}

resource "openstack_compute_floatingip_associate_v2" "tor_exit_assoc_fips" {
  count       = "${var.TOR_EXIT_NODE_COUNT}"
  floating_ip = "${element(openstack_networking_floatingip_v2.tor_exit_fips.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.tor_exit_nodes.*.id, count.index)}"

  provisioner "local-exec" {
    environment {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
    command = <<EOF
              sleep 200; \
              ansible-playbook \
                --user ${var.ANSIBLE_PLAYBOOK_USER} \
                --private-key ${var.SSH_PRIV_KEY_LOCATION} \
                --inventory '${element(openstack_networking_floatingip_v2.tor_exit_fips.*.address, count.index)},' \
                ${var.ANSIBLE_RELAYOR_EXIT_PLAYBOOK_PATH}
              EOF
  }
}
