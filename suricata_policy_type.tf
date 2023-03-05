resource "aws_networkfirewall_rule_group" "suricata_stateful_group" {
  count = length(var.suricata_stateful_rule_group) > 0 ? length(var.suricata_stateful_rule_group) : 0
  type  = "STATEFUL"

  name        = var.suricata_stateful_rule_group[count.index]["name"]
  description = var.suricata_stateful_rule_group[count.index]["description"]
  capacity    = var.suricata_stateful_rule_group[count.index]["capacity"]

  rule_group {
    rules_source {
      rules_string = file(var.suricata_stateful_rule_group[count.index]["rules_file"])
    }

    dynamic "rule_variables" {
      for_each = [
        for b in lookup(var.suricata_stateful_rule_group[count.index], "rule_variables", {}) : b
        if length(b) > 1
      ]
      content {
        dynamic "ip_sets" {
          for_each = lookup(lookup(var.suricata_stateful_rule_group[count.index], "rule_variables", {}), "ip_sets", [])
          content {
            key = ip_sets.value["key"]
            ip_set {
              definition = ip_sets.value["ip_set"]
            }
          }
        }

        dynamic "port_sets" {
          for_each = lookup(lookup(var.suricata_stateful_rule_group[count.index], "rule_variables", {}), "port_sets", [])
          content {
            key = port_sets.value["key"]
            port_set {
              definition = port_sets.value["port_sets"]
            }
          }
        }
      }
    }


  }

  # tags = merge(var.tags)
}