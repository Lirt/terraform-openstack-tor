# Intro

This terraform role uses Openstack driver to bootstrap virtual instances for Tor relays, bridges and exits.

## Provision

Setup and source your openstack credentials, or fill template with configuration for your openstack in `RCs/tf-os.rc` and source it (`source RCs/tf-os.rc`).

To configure openstack instance details and there are 2 possibilities (Result will be the same, it depends only on your taste):

1. Override all default variables in file `variables.tf` to file `terraform.tfvars`.
2. Setup and source variables in file `RCs/tf-tor.rc`.

Generate new SSH keypair (`ssh-keygen -f tor-ssh-key`), or use the name of one you have already created in Openstack.

For an inspiration how the playbook for tor might look like, look into `playbooks` folder.
