

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
    stateless_default_actions = [ "aws:forward_to_sfe" ]
    stateless_fragment_default_actions = [ "aws:forward_to_sfe" ]
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.allow_all.arn
    }
  } 
}

resource "aws_networkfirewall_rule_group" "allow_all" {
  capacity = 1000
  name = "test_rule_group"
  type = "STATEFUL"
}