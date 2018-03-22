# Intro

This terraform role uses Openstack driver to bootstrap virtual instances and Ansible role [https://github.com/nusenu/ansible-relayor](https://github.com/nusenu/ansible-relayor) to install Tor on these nodes.

## Prerequisities

Install ansible-relayor role from Ansible Galaxy by running command `ansible-galaxy install nusenu.relayor`.

To configure openstack nodes to Tor relays, bridges or exit nodes, override all variables in file `main-rc.sh`.

Example usage of variables is located in file `main-rc-example.sh`.


## Limit network bandwidth or total bandwidth per month

## Flavor constraints

To limit network bandwidth and disk operations on tor nodes, it is necessary to use flavor metadata.

This is example to limit:

* Limit IOPS to 150 or disk speed to 20MB/s
* Limit average bandwidth to 60Mbit/s; peak to 100Mbit/s, and 100MB of burst

```bash
FLAVOR_NAME=""
nova flavor-key $FLAVOR_NAME set quota:disk_total_iops_sec=150
nova flavor-key $FLAVOR_NAME set quota:disk_total_bytes_sec=20000000
nova flavor-key $FLAVOR_NAME set quota:vif_inbound_average=7500
nova flavor-key $FLAVOR_NAME set quota:vif_inbound_burst=100000
nova flavor-key $FLAVOR_NAME set quota:vif_inbound_peak=12500
nova flavor-key $FLAVOR_NAME set quota:vif_outbound_average=7500
nova flavor-key $FLAVOR_NAME set quota:vif_outbound_burst=100000
nova flavor-key $FLAVOR_NAME set quota:vif_outbound_peak=12500
