provider "openstack" {
}


data "openstack_images_image_v2" "image" {
  name        = "${var.tor_os_image_name}"
  visibility  = "public"
  most_recent = true
}

data "openstack_networking_network_v2" "public_net" {
  name = "${var.tor_os_network_name}"
}


resource "openstack_compute_keypair_v2" "tor_keypair" {
  name       = "${var.tor_os_keypair_name}"
  public_key = "${file(var.ssh_pub_key_location)}"
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
    description = "Allow Tor OR port 2"
    rule {
        ip_protocol = "tcp"
        from_port = "9100"
        to_port = "9100"
        cidr = "0.0.0.0/0"
    }
}
resource "openstack_compute_secgroup_v2" "tor_dir_1_secgroup" {
    name = "tor-allow-dir-1-all"
    description = "Allow Tor Directory port 1"
    rule {
        ip_protocol = "tcp"
        from_port = "9001"
        to_port = "9001"
        cidr = "0.0.0.0/0"
    }
}
resource "openstack_compute_secgroup_v2" "tor_dir_2_secgroup" {
    name = "tor-allow-dir-2-all"
    description = "Allow Tor Directory port 2"
    rule {
        ip_protocol = "tcp"
        from_port = "9101"
        to_port = "9101"
        cidr = "0.0.0.0/0"
    }
}
resource "openstack_compute_secgroup_v2" "tor_dir_exit_1_secgroup" {
    name = "tor-allow-dir-exit-1-all"
    description = "Allow Tor Exit Directory port 1"
    rule {
        ip_protocol = "tcp"
        from_port = "80"
        to_port = "80"
        cidr = "0.0.0.0/0"
    }
}
resource "openstack_compute_secgroup_v2" "tor_dir_exit_2_secgroup" {
    name = "tor-allow-dir-exit-2-all"
    description = "Allow Tor Exit Directory port 2"
    rule {
        ip_protocol = "tcp"
        from_port = "81"
        to_port = "81"
        cidr = "0.0.0.0/0"
    }
}


resource "openstack_compute_instance_v2" "tor_nodes" {
  count             = "${var.tor_node_count}"
  name              = "${format("${var.tor_nickname}-%02d", count.index + 1)}"
  image_id          = "${data.openstack_images_image_v2.image.id}"
  flavor_name       = "${var.tor_os_flavor_name}"
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


resource "openstack_networking_floatingip_v2" "tor_fips" {
  count = "${var.tor_node_count}"
  pool  = "${var.tor_os_ext_net_pool}"
}

resource "openstack_compute_floatingip_associate_v2" "tor_assoc_fips" {
  count       = "${var.tor_node_count}"
  floating_ip = "${element(openstack_networking_floatingip_v2.tor_fips.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.tor_nodes.*.id, count.index)}"
}
