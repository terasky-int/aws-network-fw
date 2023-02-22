# AWS Network Firewall
resource "aws_networkfirewall_firewall" "network_firewall" {
  count = var.create_aws_nfw ? 1 : 0

  name                              = var.firewall_name
  vpc_id                            = var.vpc_id
  firewall_policy_arn               = aws_networkfirewall_firewall_policy.this[0].arn
  firewall_policy_change_protection = var.firewall_policy_change_protection
  subnet_change_protection          = var.subnet_change_protection
  delete_protection                 = var.delete_protection
  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping
    content {
      subnet_id = subnet_mapping.value
    }
  }
}


resource "aws_networkfirewall_logging_configuration" "anfw_logging_configuration" {
  firewall_arn = aws_networkfirewall_firewall.network_firewall[0].arn
  logging_configuration {
    log_destination_config {
      log_destination = {
        bucketName = var.nfw_log_bucket_name
        prefix     = "${aws_networkfirewall_firewall.network_firewall[0].name}"
      }
      log_destination_type = "S3"
      log_type             = "FLOW"
    }
  }
}



