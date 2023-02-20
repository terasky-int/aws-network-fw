

# # Create Firewall
# resource "aws_networkfirewall_firewall" "network_firewall" {
#   name = var.firewall_name
#   vpc_id = var.vpc_id
#   firewall_policy_arn = aws_networkfirewall_firewall_policy.network_firewall_policy1.arn
#   subnet_mapping {
#     subnet_id = "subnet-0c2edb2d08b2af71c"

# }
# }
# # Create Firewall policy

# resource "aws_networkfirewall_firewall_policy" "network_firewall_policy1" {
#   name = var.policy_name
#   firewall_policy {
#     stateful_default_actions = [ "aws:pass" ]
#     stateless_fragment_default_actions = [ "aws:drop" ]
#     stateless_default_actions = {
      
#     }
#   }
# }


# resource "aws_networkfirewall_firewall_policy" "network_firewall_policy1" {
#   name = var.policy_name

#   firewall_policy {
#     stateless_default_actions          = ["aws:pass"]
#     stateless_fragment_default_actions = ["aws:drop"]
#     stateless_rule_group_reference {
#       priority     = 1
#       resource_arn = aws_networkfirewall_rule_group.example.arn
#     }
#   }

#   tags = {
#     Tag1 = "Value1"
#     Tag2 = "Value2"
#   }
# }


resource "aws_networkfirewall_firewall_policy" "example_policy" {
  name        = var.policy_name
  description = "Example firewall policy"
  firewall_policy {
    stateless_default_actions = ["aws:pass"]
    stateless_rule_groups = [
      {
        priority = 1
        rule_group_arn = "aws:aws:policy/allow_all"
      }
    ]
  }
}