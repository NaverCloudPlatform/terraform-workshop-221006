locals {

  steps = {
    set_ssh_rsa           = true
    install_packages      = true
    set_ansible_inventory = true
    create_users          = true
    install_cla_agent     = true
  }

  install_packages = {
    yum  = []
    snap = []
    pip  = ["ansible"]
  }

  user_names = ["workshop"]

}


output "bastion_rootpw" {
  value = {
    ip     = local.servers["svr-workshop-bastion"].public_ip
    passwd = nonsensitive(local.root_passwords["svr-workshop-bastion"])
  }
}
