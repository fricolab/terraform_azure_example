tags = {
  company     = "example"
  deleteAfter = "Never"
  environment = "dev"
  typeproject = "product"
  owner       = "user@domain.com"
  project     = "projectname"
  terraform   = "true"
}

location = "northeurope"

vm_size = "VM_size"

######## Vnet information

virtual_network_name = "vnet-name"

address_prefixes = "10.0.1.0/24"

address_space = "10.0.0.0/16"

subnet_names = ["subnet-name1", "subnet-name2", "subnet-name3"]

ip_name = "ipname"

network_security_group_name = "netgroupsecuritygroupname"

public_key = "SHA.................."

instance_data = {
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "16.04.0-LTS"
  version   = "latest"
}
