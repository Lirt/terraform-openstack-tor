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
