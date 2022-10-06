data "ncloud_root_password" "root_passwords" {
  for_each = module.servers

  server_instance_no = each.value.server.id
  private_key        = ncloud_login_key.loginkey.private_key
}

output "root_passwords" {
  value = { for server_name, root_password in data.ncloud_root_password.root_passwords :
    server_name => root_password.root_password
  }
  sensitive = true
}

output "servers" {
  value = { for server_name, server_value in module.servers :
    server_name => {
      public_ip  = server_value.server.public_ip
      private_ip = server_value.server.network_interface[0].private_ip
      server_id  = server_value.server.id
    }
  }
}


