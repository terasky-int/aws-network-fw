variable "vpc_id" {
  description = "Get your vpc id"
  type = string
}

variable "policy_name" {
  description = "Policy name"
  type = string
}

variable "firewall_name" {
  description = "Name of your network firewall"
  type = string
}


variable "public_subnet_cidrs" {
  description = "A list of CIDRs for public subnets"
  type        = list(string)
}

variable "public_subnet_suffix" {
  description = "Public subnet suffix"
  type        = string
  default     = "public"
}


variable "public_subnet_tags" {
  description = "Public subnet tags"
  type        = map(string)
  default = {
    Tier = "public"
  }
}


variable "firewall_subnet_cidrs" {
  description = "A list of CIDRs for firewall subnets"
  type        = list(string)
}

variable "firewall_subnet_suffix" {
  description = "FIrewall subnet suffix"
  type        = string
  default     = "firewall"
}

variable "firewall_subnet_tags" {
  description = "Firewall subnet tags"
  type        = map(string)
  default = {
    Tier = "firewall"
  }
}

variable "tgw_id" {
  description = "ID of Transit Gateway to create routes to"
  type        = string
}

variable "nfw_log_bucket_name" {
  description = "The name of the S3 bucket where Network Firewall logs will be pushed"
  type        = string
  default     = "aws-network-firewall-flow-logs-131324221487"
}
