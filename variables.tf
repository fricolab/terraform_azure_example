variable "tags" {
  description = "A map of tags to add to all resources"
  type        = "map"
}

variable "location" {
  description = "Location of resources in Azure"
  type = "string"
}

variable "address_space" {
  description = "List of address spaces"
  type        = "list"
}

variable "address_prefix" {
  type        = "string"
}

variable "virtual_network_name" {
  type        = "string"
}

variable "subnet_names" {
  type        = "list"
}

variable "ip_name" {
  type        = "string"

}

variable "network_security_group_name" {
  type        = "string"

}

variable "vm_size" {
  description = "Size of VM to deploy"
  type        = "string"

}

variable "public_key" {
  description = "Public SSH Key to add to VM instance"
  type        = "string"
}

variable "instance_data" {
  description = "A map of tags to define VM instance propertiees"
  type        = "map"
}
