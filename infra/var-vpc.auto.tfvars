vpcs = [
  {
    name            = "vpc-workshop"
    ipv4_cidr_block = "10.10.0.0/16"

    public_subnets = [
      {
        name        = "sbn-workshop-public"
        zone        = "KR-1"
        subnet      = "10.10.1.0/24"
        network_acl = "default"
      }
    ]
    private_subnets = [
      {
        name        = "sbn-workshop-private"
        zone        = "KR-1"
        subnet      = "10.10.2.0/24"
        network_acl = "default"
      }
    ]

    access_control_groups = [
      {
        name        = "acg-workshop-public"
        description = "ACG for public servers"
        inbound_rules = [
          ["TCP", "0.0.0.0/0", 22, "SSH allow form any"]
        ]
        outbound_rules = [
          ["TCP", "0.0.0.0/0", "1-65535", "All allow to any"],
          ["UDP", "0.0.0.0/0", "1-65535", "All allow to any"]
        ]
      },
      {
        name        = "acg-workshop-private"
        description = "ACG for private servers"
        inbound_rules = [
          ["TCP", "acg-workshop-public", 22, "SSH allow form acg-workshop-public"]
        ]
        outbound_rules = [
          ["TCP", "0.0.0.0/0", "1-65535", "All allow to any"],
          ["UDP", "0.0.0.0/0", "1-65535", "All allow to any"]
        ]
      }
    ]

    nat_gateways = [
      {
        name        = "nat-gw-workshop"
        zone        = "KR-1"
        route_table = "default"
      }
    ]
  }
]
