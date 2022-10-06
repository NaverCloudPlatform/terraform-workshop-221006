locals {
  servers     = var.servers
  module_vpcs = module.vpcs
}


locals {
  flatten_servers = flatten([for server in local.servers : server.create_multiple ?
    [
      for index in range(server.count) : merge(
        { name = format("%s-%03d", server.name_prefix, index + server.start_index) },
        { for attr_key, attr_val in server : attr_key => attr_val if(attr_key != "default_network_interface" && attr_key != "additional_block_storages") },
        { default_network_interface = merge(server.default_network_interface,
          { name = format("%s-%03d-%s", server.default_network_interface.name_prefix, index + server.start_index, server.default_network_interface.name_postfix) })
        },
        { additional_block_storages = [for vol in lookup(server, "additional_block_storages", []) : merge(vol,
          { name = format("%s-%03d-%s", vol.name_prefix, index + server.start_index, vol.name_postfix) })]
        }
      )
    ] :
    [
      merge(
        { name = server.name_prefix },
        { for attr_key, attr_val in server : attr_key => attr_val if(attr_key != "default_network_interface" && attr_key != "additional_block_storages") },
        { default_network_interface = merge(server.default_network_interface,
          { name = format("%s-%s", server.default_network_interface.name_prefix, server.default_network_interface.name_postfix) })
        },
        { additional_block_storages = [for vol in lookup(server, "additional_block_storages", []) : merge(vol,
          { name = format("%s-%s", vol.name_prefix, vol.name_postfix) })]
        }
      )
    ]
  ])
}


module "servers" {
  source = "terraform-ncloud-modules/server/ncloud"

  for_each = { for server in local.flatten_servers : server.name => server }

  name           = each.value.name
  description    = each.value.description
  subnet_id      = local.module_vpcs[each.value.vpc_name].all_subnets[each.value.subnet_name].id
  login_key_name = each.value.login_key_name

  server_image_name  = each.value.server_image_name
  product_generation = each.value.product_generation
  product_type       = each.value.product_type
  product_name       = each.value.product_name

  fee_system_type_code = lookup(each.value, "fee_system_type_code", "MTRAT")

  is_associate_public_ip                 = lookup(each.value, "is_associate_public_ip", false)
  is_protect_server_termination          = lookup(each.value, "is_protect_server_termination", false)
  is_encrypted_base_block_storage_volume = lookup(each.value, "is_encrypted_base_block_storage_volume", false)

  default_network_interface = {
    name        = each.value.default_network_interface.name
    description = lookup(each.value.default_network_interface, "description", null)
    private_ip  = lookup(each.value.default_network_interface, "private_ip", null)
    access_control_group_ids = [for acg_name in lookup(each.value.default_network_interface, "access_control_groups", ["default"]) :
      acg_name == "default" ? local.module_vpcs[each.value.vpc_name].vpc.default_access_control_group_no : local.module_vpcs[each.value.vpc_name].access_control_groups[acg_name].id
    ]
  }

  additional_block_storages = [for vol in lookup(each.value, "additional_block_storages", []) :
    {
      name        = vol.name
      description = lookup(vol, "description", null)
      disk_type   = lookup(vol, "disk_type", "SSD")
      size        = vol.size
    }
  ]
}