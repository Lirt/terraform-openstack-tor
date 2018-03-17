# Prerequisities

To configure openstack nodes to Tor relays, bridges or exit nodes, prepare yaml configuration file for ansible-relayor module. Path to file can be specified in rc file as environment variable.

Then you can install ansible-relayor from Galaxy by running command `ansible-galaxy install nusenu.relayor`.

Last step of this terraform repository is to create inventory from floating addresses given by openstack and running ansible-playbook.

```bash
ansible-galaxy install kyungw00k.python27 nusenu.relayor
```

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
