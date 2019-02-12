# Intro

This terraform role uses Openstack driver to bootstrap virtual instances and Ansible role [Ansible Relayor](https://github.com/nusenu/ansible-relayor) to install Tor on newly created openstack nodes.

## Prerequisities

Install `ansible-relayor` role from Ansible Galaxy by running command `ansible-galaxy install nusenu.relayor`.

## Provision

Setup and source your openstack credentials, or fill template with configuration for your openstack in `RCs/tf-os.rc` and source it.

To configure openstack instance details and ansible playbook there are 2 possibilities:

1. Override all default variables in file `variables.tf` to file `terraform.tfvars`.
2. Setup and source variables in file `RCs/tf-tor.rc`.

Result will be the same, it depends only on your taste.

Generate new SSH keypair (`ssh-keygen -f tor-ssh-key`), or use one you have already created in Openstack.

For an inspiration how the playbook for tor might look like, look into `playbooks` folder.
