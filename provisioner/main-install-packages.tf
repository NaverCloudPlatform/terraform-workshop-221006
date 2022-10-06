
resource "null_resource" "install_packages" {
  count      = local.steps.install_packages ? 1 : 0
  depends_on = [null_resource.set_ssh_rsa]

  provisioner "remote-exec" {
    inline = ["mkdir -p /root/scripts"]
  }

  provisioner "file" {
    content     = templatefile("scripts/install-packages.sh", local.install_packages)
    destination = "/root/scripts/install-packages.sh"
  }

  provisioner "remote-exec" {
    inline = ["sh /root/scripts/install-packages.sh;"]
  }

  triggers = {
    file      = filesha1("scripts/install-packages.sh"),
    variables = jsonencode(local.install_packages)
  }

  connection {
    type     = "ssh"
    host     = local.servers["svr-workshop-bastion"].public_ip
    port     = "22"
    user     = "root"
    password = local.root_passwords["svr-workshop-bastion"]
  }


}
