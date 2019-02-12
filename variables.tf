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

variable "tor_os_network_name" {
  description = "Name of openstack network with external connection that will be used as primary tor network. It MUST already exist."
}

variable "tor_os_flavor_name" {
  description = "Name of openstack flavor used to bootstrap tor instances. It MUST already exist."
}

variable "tor_os_image_name" {
  description = "Name of openstack image used to bootstrap tor instances. It MUST already exist."
}

variable "tor_os_ext_net_pool" {
  description = "Name of openstack external network used for assigning floating IP addresses. It MUST already exist."
}

variable "tor_os_keypair_name" {
  description = "Name of openstack keypair that will be created and assigned to all created tor instances."
}

variable "tor_node_count" {
  description = "Number of tor nodes to create."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "ssh_priv_key_location" {
  description = "Path to private SSH key that will be used to connect to tor instance with ansible."
  default = "./tor-ssh-key"
}

variable "ssh_pub_key_location" {
  description = "Path to public SSH key that will be used to create a keypair."
  default = "./tor-ssh-key.pub"
}

variable "tor_nickname" {
  description = "Nickname for tor nodes. Two digit number will be appended to end of the name to keep them unique."
  default = "tor-tf-node"
}
