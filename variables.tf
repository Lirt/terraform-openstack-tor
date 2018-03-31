variable "TOR_OS_NETWORK_NAME" {
  description = "Name of openstack network with external connection that will be used as primary tor network. It must already exist."
  default = "public-net"
}
variable "TOR_OS_FLAVOR_NAME" {
  description = "Name of openstack flavor used to bootstrap tor instances. It must already exist."
  default = "t2.small"
}
variable "TOR_OS_IMAGE_NAME" {
  description = "Name of openstack image used to bootstrap tor instances. It must already exist."
  default = "ubuntu-16.04"
}
variable "TOR_OS_EXT_NET_POOL" {
  description = "Name of openstack external network used for assigning floating IP addresses. It must already exist."
  default = "ext-net"
}
variable "TOR_OS_KEYPAIR_NAME" {
  description = "Name of openstack keypair that will be created and assigned to all created tor instances."
  default = "tor-tf-ssh-key"
}

variable "SSH_PUB_KEY_LOCATION" {
  description = "Path to public SSH key that will be used to create a keypair."
  default = "./tor-ssh-key.pub"
}
variable "SSH_PRIV_KEY_LOCATION" {
  description = "Path to private SSH key that will be used to connect to tor instance with ansible."
  default = "./tor-ssh-key.rsa"
}

variable "TOR_RELAY_NODE_COUNT" {
  description = "Number of tor relay nodes to create."
  default = 1
}
variable "TOR_RELAY_NICKNAME" {
  description = "Nickname for tor relay nodes. Two digit number will be appended to end of the name to keep them unique."
  default = "tor-tf-relay"
}
variable "TOR_EXIT_NODE_COUNT" {
  description = "Number of tor exit nodes to create."
  default = 0
}
variable "TOR_EXIT_NICKNAME" {
  description = "Nickname for tor exit nodes. Two digit number will be appended to end of the name to keep them unique."
  default = "tor-tf-exit"
}

variable "ANSIBLE_RELAYOR_RELAY_PLAYBOOK_PATH" {
  description = "Path to ansible playbook used to provision tor relay nodes."
  default = "playbooks/relay-node.yml"
}
variable "ANSIBLE_RELAYOR_EXIT_PLAYBOOK_PATH" {
  description = "Path to ansible playbook used to provision tor exit nodes."
  default = "playbooks/exit-node.yml"
}
variable "ANSIBLE_PLAYBOOK_USER" {
  description = "User that will be used to connect to instances via ansible SSH."
  default = "ubuntu"
}
