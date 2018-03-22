# Intro

This terraform role uses Openstack driver to bootstrap virtual instances and Ansible role [https://github.com/nusenu/ansible-relayor](https://github.com/nusenu/ansible-relayor) to install Tor on created openstack nodes.

## Prerequisities

Install `ansible-relayor` role from Ansible Galaxy by running command `ansible-galaxy install nusenu.relayor`.

## Provision

Setup and source your openstack credentials, or fill template with configuration for your openstack in `tf-os.rc` and source it.

To configure openstack instance details and ansible playbook there are 2 possibilities:

1. Override all default variables in file `variables.tf` to file `terraform.tfvars`.
2. Setup and source variables in file `tf-tor.rc`.

Result will be the same, it depends only on your taste.

Remember that if you decide to source parameters from `rc` files, you need to do it every time you make a change.

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
