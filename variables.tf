variable "TOR_OS_NETWORK_NAME" {
  default = "public-net"
}
variable "TOR_OS_FLAVOR_NAME" {
  default = "t2.small"
}
variable "TOR_OS_IMAGE_NAME" {
  default = "ubuntu-16.04"
}
variable "TOR_OS_EXT_NET_POOL" {
  default = "ext-net"
}
variable "TOR_OS_KEYPAIR_NAME" {
  default = "tor-tf-ssh-key"
}

variable "SSH_PUB_KEY_LOCATION" {
  default = "./tor-ssh-key.pub"
}
variable "SSH_PRIV_KEY_LOCATION" {
  default = "./tor-ssh-key.rsa"
}

variable "TOR_RELAY_NODE_COUNT" {
  default = 1
}
variable "TOR_RELAY_NICKNAME" {
  default = "tor-tf-relay"
}
variable "TOR_EXIT_NODE_COUNT" {
  default = 0
}
variable "TOR_EXIT_NICKNAME" {
  default = "tor-tf-exit"
}

variable "ANSIBLE_RELAYOR_RELAY_PLAYBOOK_PATH" {
  default = "playbooks/relay-node.yml"
}
variable "ANSIBLE_RELAYOR_EXIT_PLAYBOOK_PATH" {
  default = "playbooks/exit-node.yml"
}
variable "ANSIBLE_PLAYBOOK_USER" {
  default = "ubuntu"
}
