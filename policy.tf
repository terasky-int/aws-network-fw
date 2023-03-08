resource "aws_networkfirewall_firewall_policy" "this" {
  count = var.enable_aws_nfw ? 1 : 0

  name = var.policy_name

  firewall_policy {
    stateless_default_actions          = var.stateless_default_actions
    stateless_fragment_default_actions = var.stateless_fragment_default_actions

    # Stateless rule group reference
    dynamic "stateless_rule_group_reference" {
      for_each = local.this_stateless_group_arn
      content {
        # Priority is sequentially as per index in stateless_rule_group list
        priority     = index(local.this_stateless_group_arn, stateless_rule_group_reference.value) + 1
        resource_arn = stateless_rule_group_reference.value
      }
    }
    dynamic "stateful_rule_group_reference" {
      for_each = local.this_stateful_group_arn
      content {
        resource_arn = stateful_rule_group_reference.value
      }
    }

  }


}

# Stateless rule groups
resource "aws_networkfirewall_rule_group" "stateless_group" {
  count = length(var.stateless_rule_group) > 0 ? length(var.stateless_rule_group) : 0
  type  = "STATELESS"

  name        = var.stateless_rule_group[count.index]["name"]
  description = var.stateless_rule_group[count.index]["description"]
  capacity    = var.stateless_rule_group[count.index]["capacity"]

  rule_group {
    rules_source {
      stateless_rules_and_custom_actions {
        dynamic "stateless_rule" {
          for_each = var.stateless_rule_group[count.index].rule_config
          content {
            priority = stateless_rule.value.priority
            rule_definition {
              actions = ["aws:${stateless_rule.value.actions["type"]}"]
              match_attributes {
                source {
                  address_definition = stateless_rule.value.source_ipaddress
                }
                # If protocol is TCP : 6 or UDP :17 get source ports from variables and set in source_port block
                dynamic "source_port" {
                  for_each = contains(stateless_rule.value.protocols_number, 6) || contains(stateless_rule.value.protocols_number, 17) ? try(toset([{
                    from = stateless_rule.value.source_from_port,
                    to   = stateless_rule.value.source_to_port
                  }]), []) : []
                  content {
                    from_port = source_port.value.from
                    to_port   = source_port.value.to
                  }
                }
                destination {
                  address_definition = stateless_rule.value.destination_ipaddress
                }
                # If protocol is TCP : 6 or UDP :17 get destination ports from variables and set in destination_port block
                dynamic "destination_port" {
                  for_each = contains(stateless_rule.value.protocols_number, 6) || contains(stateless_rule.value.protocols_number, 17) ? try(toset([{
                    from = stateless_rule.value.destination_from_port,
                    to   = stateless_rule.value.destination_to_port
                  }]), []) : []
                  content {
                    from_port = destination_port.value.from
                    to_port   = destination_port.value.to
                  }
                }
                protocols = stateless_rule.value.protocols_number
                dynamic "tcp_flag" {
                  for_each = contains(stateless_rule.value.protocols_number, 6) || contains(stateless_rule.value.protocols_number, 17) ? try(toset([{
                    flag  = stateless_rule.value.tcp_flag["flags"],
                    masks = stateless_rule.value.tcp_flag["masks"]
                  }]), []) : []
                  content {
                    flags = tcp_flag.value.flag
                    masks = tcp_flag.value.masks
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  # tags = merge(var.tags)
}
