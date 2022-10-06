servers = [
  {
    create_multiple = false

    name_prefix    = "svr-workshop-bastion"
    description    = "workshop bastion server"
    vpc_name       = "vpc-workshop"
    subnet_name    = "sbn-workshop-public"
    login_key_name = "key-workshop"

    server_image_name  = "CentOS 7.8 (64-bit)"
    product_generation = "G2"
    product_type       = "High CPU"
    product_name       = "vCPU 2EA, Memory 4GB, [SSD]Disk 50GB"

    is_associate_public_ip = true

    default_network_interface = {
      name_prefix           = "nic-workshop-bastion"
      name_postfix          = "def"
      description           = "default nic for svr-workshop-bastion"
      access_control_groups = ["acg-workshop-public"]
    }
  },
  {
    create_multiple = true
    count           = 3
    start_index     = 1

    name_prefix    = "svr-workshop-worker"
    description    = "workshop worker server"
    vpc_name       = "vpc-workshop"
    subnet_name    = "sbn-workshop-private"
    login_key_name = "key-workshop"

    server_image_name  = "CentOS 7.8 (64-bit)"
    product_generation = "G2"
    product_type       = "High CPU"
    product_name       = "vCPU 2EA, Memory 4GB, [SSD]Disk 50GB"

    is_associate_public_ip = false

    default_network_interface = {
      name_prefix           = "nic-workshop-worker"
      name_postfix          = "def"
      description           = "default nic for svr-workshop-worker"
      access_control_groups = ["acg-workshop-private"]
    }
  },

]
