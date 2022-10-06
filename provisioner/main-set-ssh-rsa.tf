locals {
  set_ssh_rsa_vars = {
    SERVERS = local.servers
    ROOT_PWS   = nonsensitive(local.root_passwords)
  }
}

resource "null_resource" "set_ssh_rsa" {
  count = local.steps.set_ssh_rsa ? 1 : 0

  provisioner "remote-exec" {
    inline = ["mkdir -p /root/scripts"]
  }

  provisioner "file" {
    content     = templatefile("scripts/set-ssh-rsa.sh", local.set_ssh_rsa_vars)
    destination = "/root/scripts/set-ssh-rsa.sh"
  }

  provisioner "remote-exec" {
    inline = ["sh /root/scripts/set-ssh-rsa.sh"]
  }

  triggers = {
    file      = filesha1("scripts/set-ssh-rsa.sh")
    variables = jsonencode(local.set_ssh_rsa_vars)
  }

  connection {
    type     = "ssh"
    host     = local.servers["svr-workshop-bastion"].public_ip
    port     = "22"
    user     = "root"
    password = local.root_passwords["svr-workshop-bastion"]
  }
}
