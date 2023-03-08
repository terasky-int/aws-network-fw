variable "create_anfw_logs_to_cloudwatch" {
  description = "Enable or disable stream logs to cloudwatch"
  type        = bool
}
variable "create_anfw_logs_to_s3" {
  description = "Enable or disable stream logs from anfw to s3"
  type        = bool
}
variable "bucket_name_logging" {
  description = "Name of s3 for logging"
  type        = string
}

variable "firewall_name" {
  description = "Network firewall name"
  type        = string
}

variable "policy_name" {
  description = "Policy name that attached to your network firewall"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID of Inspection vpc"
  type        = string
}

variable "subnet_mapping" {
  type        = list(string)
  description = "Subnets map. Each subnet must belong to a different Availability Zone in the VPC. AWS Network Firewall creates a firewall endpoint in each subnet."
}

variable "enable_aws_nfw" {
  description = "Change to false to avoid deploying AWS Network Firewall resources."
  type        = bool
  default     = true
}

variable "stateless_fragment_default_actions" {
  description = "Set of actions to take on a fragmented packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: `aws:drop`, `aws:pass`, or `aws:forward_to_sf`e. In addition, you can specify custom actions that are compatible with your standard action choice. If you want non-matching packets to be forwarded for stateful inspection, specify `aws:forward_to_sfe`."
  type        = list(any)
  default     = ["aws:drop"]
}

variable "firewall_policy_change_protection" {
  description = "A boolean flag indicating whether it is possible to change the associated firewall policy."
  type        = bool
  default     = false
}

variable "subnet_change_protection" {
  description = "A boolean flag indicating whether it is possible to change the associated subnet(s)."
  type        = bool
  default     = false
}

variable "delete_protection" {
  description = "A boolean flag indicating whether it is possible to delete the firewall."
  type        = bool
  default     = false
}

variable "prefix_environmnet" {
  type        = string
  description = "Name of your environmnet"
}

# Stateful rules
variable "stateful_rule_groups" {
  type        = any
  description = "Map of stateful rules groups."
  default     = {}
}

# Stateless rule group
variable "stateless_rule_groups" {
  type        = any
  description = "Map of stateless rules groups."
  default     = {}
}

variable "stateless_default_actions" {
  description = "Set of actions to take on a packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: `aws:drop`, `aws:pass`, or `aws:forward_to_sf`e. In addition, you can specify custom actions that are compatible with your standard action choice. If you want non-matching packets to be forwarded for stateful inspection, specify `aws:forward_to_sfe`."
  type        = list(any)
  default     = ["aws:drop"]
}

variable "nfw_log_bucket_name" {
  description = "S3 for logging"
  type        = string
}

variable "fivetuple_stateful_rule_group" {
  default     = []
  type        = any
  description = <<-EOF
  "Config for 5-tuple type stateful rule group"
fivetuple_stateful_rule_group = [
        {
        capacity    = 100
        name        = "stateful"
        description = "Stateful rule example1 with 5 tuple option"
        rule_config = [{
            description           = "Pass All Rule"
            protocol              = "TCP"
            source_ipaddress      = "1.2.3.4/32"
            source_port           = 443
            destination_ipaddress = "124.1.1.5/32"
            destination_port      = 443
            direction             = "any"
            sid                   = 1
            actions = {
            type = "pass"
            }
        }]
        },
    ]
  EOF
}

variable "suricata_stateful_rule_group" {
  default     = []
  type        = any
  description = <<-EOF
  "Config for Suricata type stateful rule group"

suricata_stateful_rule_group = [
    {
        capacity    = 100
        name        = "SURICTASFEXAMPLE1"
        description = "Stateful rule example1 with suricta type"
        rules_file  = "./example.rules"
    }]
EOF
}


variable "domain_stateful_rule_group" {
  default     = []
  type        = any
  description = <<-EOF
  "Config for domain type stateful rule group"
domain_stateful_rule_group = [
    {
        capacity    = 100
        name        = "DOMAINSFEXAMPLE1"
        description = "Stateful rule example1 with domain list option"
        domain_list = ["test.example.com", "test1.example.com"]
        actions     = "DENYLIST"
        protocols   = ["HTTP_HOST", "TLS_SNI"]
        rule_variables = {
            ip_sets = [{
                key    = "WEBSERVERS_HOSTS"
                ip_set = ["10.0.0.0/16", "10.0.1.0/24", "192.168.0.0/16"]
            },
            {
                key    = "EXTERNAL_HOST"
                ip_set = ["0.0.0.0/0"]
            }]
            port_sets = [
            {
                key       = "HTTP_PORTS"
                port_sets = ["443", "80"]
            }]
        }
    }]
    EOF
}

variable "aws_managed_rule_group" {
  description = "List of AWS managed rule group arn"
  type        = list(any)
  default     = []
}

variable "stateless_rule_group" {
  type        = any
  description = <<-EOF
  "Config for stateless rule group"

    stateless_rule_group = [
        {
        capacity    = 100
        name        = "stateless"
        description = "Stateless rule example1"
        rule_config = [{
            priority              = 1
            protocols_number      = [6]
            source_ipaddress      = "1.2.3.4/32"
            source_from_port      = 443
            source_to_port        = 443
            destination_ipaddress = "124.1.1.5/32"
            destination_from_port = 443
            destination_to_port   = 443
            tcp_flag = {
            flags = ["SYN"]
            masks = ["SYN", "ACK"]
            }
            actions = {
            type = "pass"
            }
        }]
        }]
        EOF
}