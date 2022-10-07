resource "ncloud_login_key" "loginkey" {
  key_name = "key-workshop"
  
  lifecycle {
    prevent_destroy = true
  }
}

resource "local_file" "login_key" {
  filename        = format("./%s.pem", ncloud_login_key.loginkey.key_name)
  content         = ncloud_login_key.loginkey.private_key
  file_permission = "0400"

  lifecycle {
    prevent_destroy = true
  }
}
