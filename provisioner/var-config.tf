locals {
  root_passwords = sensitive(data.terraform_remote_state.infra.outputs.root_passwords)
  servers        = data.terraform_remote_state.infra.outputs.servers
}

variable "access_key" {}
variable "secret_key" {}
variable "temp_user_password" {}
