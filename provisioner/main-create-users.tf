locals {
  create_users_vars = {
    user_names = local.user_names
  }
}

resource "null_resource" "create_users" {
  count      = local.steps.create_users ? 1 : 0
  depends_on = [null_resource.set_ansible_inventory]

  provisioner "remote-exec" {
    inline = ["mkdir -p /root/playbooks"]
  }

  provisioner "file" {
    content     = templatefile("playbooks/create-users.yaml", local.create_users_vars)
    destination = "/root/playbooks/create-users.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "ansible-playbook -i /root/playbooks/inventory.ini /root/playbooks/create-users.yaml -e 'password=${var.temp_user_password}'"
    ]
  }

  triggers = {
    file1     = filesha1("playbooks/create-users.yaml")
    file2     = filesha1("playbooks/inventory.ini")
    variables = jsonencode(local.create_users_vars)
  }


  connection {
    type     = "ssh"
    host     = local.servers["svr-workshop-bastion"].public_ip
    port     = "22"
    user     = "root"
    password = local.root_passwords["svr-workshop-bastion"]
  }
}
