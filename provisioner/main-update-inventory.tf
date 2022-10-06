locals {
  set_ansible_inventory_vars = {
    SERVERS = local.servers
  }
}

resource "null_resource" "set_ansible_inventory" {
  count      = local.steps.set_ansible_inventory ? 1 : 0
  depends_on = [null_resource.install_packages]

  provisioner "remote-exec" {
    inline = ["mkdir -p /root/playbooks"]
  }

  provisioner "file" {
    content     = templatefile("playbooks/inventory.ini", local.set_ansible_inventory_vars)
    destination = "/root/playbooks/inventory.ini"
  }

  triggers = {
    variables = jsonencode(local.set_ansible_inventory_vars)
    file      = filesha1("playbooks/inventory.ini")
  }

  connection {
    type     = "ssh"
    host     = local.servers["svr-workshop-bastion"].public_ip
    port     = "22"
    user     = "root"
    password = local.root_passwords["svr-workshop-bastion"]
  }
}
