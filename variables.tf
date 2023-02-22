variable "firewall_name" {
  type = string
}

variable "policy_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_mapping" {
  type        = list(string)
  description = "Subnets map. Each subnet must belong to a different Availability Zone in the VPC. AWS Network Firewall creates a firewall endpoint in each subnet."
}

variable "create_aws_nfw" {
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
  type = string
  default = ""
}


