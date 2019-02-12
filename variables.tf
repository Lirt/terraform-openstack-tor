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

variable "tor_relay_node_count" {
  description = "Number of tor relay nodes to create."
}

variable "tor_exit_node_count" {
  description = "Number of tor exit nodes to create."
}

variable "ansible_relayor_relay_playbook_path" {
  description = "Path to ansible playbook used to provision tor relay nodes."
}

variable "ansible_relayor_exit_playbook_path" {
  description = "Path to ansible playbook used to provision tor exit nodes."
}

variable "ansible_playbook_user" {
  description = "User that will be used to connect to instances via ansible SSH. Usually depends on image and Linux/UNIX distribution."
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

variable "tor_relay_nickname" {
  description = "Nickname for tor relay nodes. Two digit number will be appended to end of the name to keep them unique."
  default = "tor-tf-relay"
}

variable "tor_exit_nickname" {
  description = "Nickname for tor exit nodes. Two digit number will be appended to end of the name to keep them unique."
  default = "tor-tf-exit"
}
