resource "aws_networkfirewall_rule_group" "fivetuple_stateful_group" {
  count = length(var.fivetuple_stateful_rule_group) > 0 ? length(var.fivetuple_stateful_rule_group) : 0
  type  = "STATEFUL"

  name        = var.fivetuple_stateful_rule_group[count.index]["name"]
  description = var.fivetuple_stateful_rule_group[count.index]["description"]
  capacity    = var.fivetuple_stateful_rule_group[count.index]["capacity"]

  rule_group {
    rules_source {
      dynamic "stateful_rule" {
        for_each = var.fivetuple_stateful_rule_group[count.index].rule_config
        content {
          action = upper(stateful_rule.value.actions["type"])
          header {
            destination      = stateful_rule.value.destination_ipaddress
            destination_port = stateful_rule.value.destination_port
            direction        = upper(stateful_rule.value.direction)
            protocol         = upper(stateful_rule.value.protocol)
            source           = stateful_rule.value.source_ipaddress
            source_port      = stateful_rule.value.source_port
          }
          rule_option {
            keyword  = "sid"
            settings = ["${stateful_rule.value.sid}; msg:\"${try(stateful_rule.value.description, "")}\""]
          }
        }
      }
    }
  }

#   tags = merge(var.tags)
}