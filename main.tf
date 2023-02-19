# Create subnet 
data "aws_subnet" "subnet" {
  vpc_id = "vpc-0b6f28f8eb88d1b4f"
}

# Create Firewall
resource "aws_networkfirewall_firewall" "network_firewall" {
  name = var.firewall_name
  vpc_id = var.vpc_id
  firewall_policy_arn = aws_networkfirewall_firewall_policy.network_firewall_policy1
    dynamic "subnet_mapping" {
    for_each = data.aws_subnet.subnet[*].id

    content {
      subnet_id = subnet.value
    }
  }

}

# Create Firewall policy

resource "aws_networkfirewall_firewall_policy" "network_firewall_policy1" {
  name = var.policy_name
  firewall_policy {
    stateful_default_actions = [ "aws:pass" ]
    stateless_fragment_default_actions = [ "aws:pass" ]
    stateless_default_actions = [ "aws:pass" ]
  }
}


