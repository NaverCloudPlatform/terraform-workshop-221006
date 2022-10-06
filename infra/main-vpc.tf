locals {
  vpcs = var.vpcs
}

module "vpcs" {
  source = "terraform-ncloud-modules/vpc/ncloud"

  for_each = { for vpc in local.vpcs : vpc.name => vpc }

  name            = each.value.name
  ipv4_cidr_block = each.value.ipv4_cidr_block

  public_subnets       = lookup(each.value, "public_subnets", [])
  private_subnets      = lookup(each.value, "private_subnets", [])
  loadbalancer_subnets = lookup(each.value, "loadbalancer_subnets", [])

  network_acls      = lookup(each.value, "network_acls", [])
  deny_allow_groups = lookup(each.value, "deny_allow_groups", [])

  access_control_groups = lookup(each.value, "access_control_groups", [])

  public_route_tables  = lookup(each.value, "public_route_tables", [])
  private_route_tables = lookup(each.value, "private_route_tables", [])

  nat_gateways = lookup(each.value, "nat_gateways", [])
}
