provider "ncloud" {
  region      = "KR"
  site        = "public"
  support_vpc = true
}

terraform {
  required_providers {
    ncloud = {
      source = "navercloudplatform/ncloud"
    }
  }
}
