# AWS Network Firewall
resource "aws_networkfirewall_firewall" "network_firewall" {
count = var.enabled ? 1 : 0

  name                = var.firewall_name
  vpc_id              = var.vpc_id
  firewall_policy_arn = aws_networkfirewall_firewall_policy.this[0].arn
  firewall_policy_change_protection = var.firewall_policy_change_protection
  subnet_change_protection = var.subnet_change_protection
  delete_protection = var.delete_protection
  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping
    content {
      subnet_id = subnet_mapping.value
    }
  }
}




