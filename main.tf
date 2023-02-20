

# Create Firewall
resource "aws_networkfirewall_firewall" "network_firewall" {
  name = var.firewall_name
  vpc_id = var.vpc_id
  firewall_policy_arn = aws_networkfirewall_firewall_policy.policy_allow_all.arn
  subnet_mapping {
    subnet_id = "subnet-0c2edb2d08b2af71c"
}
}

resource "aws_networkfirewall_firewall_policy" "policy_allow_all" {
  name = var.policy_name
  firewall_policy {
    stateless_default_actions = [ "aws:pass" ]
    stateless_fragment_default_actions = [ "aws:pass" ]
  }
}