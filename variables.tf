# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------
#
# OS_USERNAME
# OS_PASSWORD
# OS_PROJECT_NAME
# OS_ENDPOINT_TYPE
# OS_AUTH_URL
# OS_REGION_NAME
#
# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "TOR_OS_NETWORK_NAME" {
  description = "Name of openstack network with external connection that will be used as primary tor network. It MUST already exist."
}

variable "TOR_OS_FLAVOR_NAME" {
  description = "Name of openstack flavor used to bootstrap tor instances. It MUST already exist."
}

variable "TOR_OS_IMAGE_NAME" {
  description = "Name of openstack image used to bootstrap tor instances. It MUST already exist."
}

variable "TOR_OS_EXT_NET_POOL" {
  description = "Name of openstack external network used for assigning floating IP addresses. It MUST already exist."
}

variable "TOR_OS_KEYPAIR_NAME" {
  description = "Name of openstack keypair that will be created and assigned to all created tor instances."
}

variable "TOR_RELAY_NODE_COUNT" {
  description = "Number of tor relay nodes to create."
}

variable "TOR_EXIT_NODE_COUNT" {
  description = "Number of tor exit nodes to create."
}

variable "ANSIBLE_RELAYOR_RELAY_PLAYBOOK_PATH" {
  description = "Path to ansible playbook used to provision tor relay nodes."
}

variable "ANSIBLE_RELAYOR_EXIT_PLAYBOOK_PATH" {
  description = "Path to ansible playbook used to provision tor exit nodes."
}

variable "ANSIBLE_PLAYBOOK_USER" {
  description = "User that will be used to connect to instances via ansible SSH. Usually depends on image and Linux/UNIX distribution."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "SSH_PRIV_KEY_LOCATION" {
  description = "Path to private SSH key that will be used to connect to tor instance with ansible."
  default = "./tor-ssh-key"
}

variable "SSH_PUB_KEY_LOCATION" {
  description = "Path to public SSH key that will be used to create a keypair."
  default = "./tor-ssh-key.pub"
}

variable "TOR_RELAY_NICKNAME" {
  description = "Nickname for tor relay nodes. Two digit number will be appended to end of the name to keep them unique."
  default = "tor-tf-relay"
}

variable "TOR_EXIT_NICKNAME" {
  description = "Nickname for tor exit nodes. Two digit number will be appended to end of the name to keep them unique."
  default = "tor-tf-exit"
}
