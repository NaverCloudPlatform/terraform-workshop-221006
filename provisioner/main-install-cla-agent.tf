locals {
  install_cla_agent_vars = {
    access_key = var.access_key
    secret_key = var.secret_key
    servers    = local.servers
  }
}

resource "null_resource" "install_cla_agent" {
  count      = local.steps.install_cla_agent ? 1 : 0
  depends_on = [null_resource.create_users]

  provisioner "file" {
    content     = templatefile("scripts/call-cla-api.sh", local.install_cla_agent_vars)
    destination = "/root/scripts/call-cla-api.sh"
  }

  provisioner "file" {
    content     = templatefile("playbooks/install-cla-agent.yaml", {})
    destination = "/root/playbooks/install-cla-agent.yaml"
  }

  provisioner "remote-exec" {
    inline = ["sh /root/scripts/call-cla-api.sh"]
  }

  triggers = {
    file1     = filesha1("scripts/call-cla-api.sh")
    file2     = filesha1("playbooks/install-cla-agent.yaml")
    file3     = filesha1("playbooks/inventory.ini")
    variables = jsonencode(local.install_cla_agent_vars)
  }

  connection {
    type     = "ssh"
    host     = local.servers["svr-workshop-bastion"].public_ip
    port     = "22"
    user     = "root"
    password = local.root_passwords["svr-workshop-bastion"]
  }
}
