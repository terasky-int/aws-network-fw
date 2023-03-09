resource "aws_networkfirewall_rule_group" "domain_stateful_group" {
  
  count = length(var.domain_stateful_rule_group) > 0 ? length(var.domain_stateful_rule_group) : 0
  type  = "STATEFUL"

  name        = var.domain_stateful_rule_group[count.index]["name"]
  description = var.domain_stateful_rule_group[count.index]["description"]
  capacity    = var.domain_stateful_rule_group[count.index]["capacity"]

  rule_group {
    dynamic "rule_variables" {
      for_each = [
        for b in lookup(var.domain_stateful_rule_group[count.index], "rule_variables", {}) : b
        if length(b) > 1
      ]
      content {
        dynamic "ip_sets" {
          for_each = lookup(lookup(var.domain_stateful_rule_group[count.index], "rule_variables", {}), "ip_sets", [])
          content {
            key = ip_sets.value["key"]
            ip_set {
              definition = ip_sets.value["ip_set"]
            }
          }
        }

        dynamic "port_sets" {
          for_each = lookup(lookup(var.domain_stateful_rule_group[count.index], "rule_variables", {}), "port_sets", [])
          content {
            key = port_sets.value["key"]
            port_set {
              definition = port_sets.value["port_sets"]
            }
          }
        }
      }
    }

    rules_source {
      rules_source_list {
        generated_rules_type = var.domain_stateful_rule_group[count.index]["actions"]
        target_types         = var.domain_stateful_rule_group[count.index]["protocols"]
        # targets              = var.domain_stateful_rule_group[count.index]["domain_list"]
        targets = compact(split("\n", file("../aws-lz-blueprint/allowed_domains.txt")))
      }
    }
  }

  # tags = merge(var.tags)
}