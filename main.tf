# Create Firewall

resource "aws_networkfirewall_firewall" "network_firewall" {
  name = var.firewall_name
  vpc_id = var.vpc_id
  firewall_policy_arn = aws_networkfirewall_firewall_policy.network_firewall_policy1
}

# Create Firewall policy

resource "aws_networkfirewall_firewall_policy" "network_firewall_policy1" {
  name = var.policy_name
  firewall_policy {
    stateful_default_actions = [ "aws:pass" ]
    stateless_fragment_default_actions = [ "aws:pass" ]
  }
}


