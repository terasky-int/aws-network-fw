###################################
#Create AWS Netwrok Firewall
###################################
resource "aws_networkfirewall_firewall" "network_firewall" {
  count = var.enable_aws_nfw ? 1 : 0

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


###################### Logging Config ######################
resource "aws_cloudwatch_log_group" "anfw_alert_log_group" {
  
  name = "/aws/${var.prefix_environmnet}/network-firewall/alert"
}

resource "aws_s3_bucket" "s3_logs_anfw" {
  provider = aws.log
  count         = var.create_anfw_logs_to_s3 ? 1 : 0
  bucket        = var.bucket_name_logging
  # force_destroy = true
}

resource "aws_s3_bucket_acl" "logging_bucket_acl" {
  provider = aws.log
  count  = var.create_anfw_logs_to_s3 ? 1 : 0
  bucket = aws_s3_bucket.s3_logs_anfw[0].id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
provider = aws.log
  bucket = aws_s3_bucket.s3_logs_anfw[0].id
  policy = data.aws_iam_policy_document.policy.json
}


resource "aws_networkfirewall_logging_configuration" "anfw_logging_configuration_s3" {
  

  count        = var.enable_aws_nfw && var.create_anfw_logs_to_s3 ? 1 : 0
  firewall_arn = aws_networkfirewall_firewall.network_firewall[0].arn
  logging_configuration {
    log_destination_config {
      log_destination = {
        bucketName = var.bucket_name_logging
        prefix     = "${aws_networkfirewall_firewall.network_firewall[0].name}-logs"
      }
      log_destination_type = "S3"
      log_type             = "FLOW"
    }
  }
}


resource "aws_networkfirewall_logging_configuration" "anfw_logging_cloudwatch" {
  
  depends_on = [
    aws_networkfirewall_firewall.network_firewall
  ]
  count = var.create_anfw_logs_to_cloudwatch && var.enable_aws_nfw ? 1 : 0

  firewall_arn = aws_networkfirewall_firewall.network_firewall[0].arn
  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.anfw_alert_log_group.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }
  }

}