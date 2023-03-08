

output "id" {
  value = var.enable_aws_nfw ? aws_networkfirewall_firewall.network_firewall[0].id : null
  description = "Created Network Firewall ID from network_firewall module"
}

output "arn" {
  description = "Created Network Firewall ARN from network_firewall module"
  value       = var.enable_aws_nfw ? aws_networkfirewall_firewall.network_firewall[0].arn : null
}

output "endpoint_ids" {
  value = var.enable_aws_nfw ? flatten(aws_networkfirewall_firewall.network_firewall[0].firewall_status[*].sync_states[*].attachment[*].endpoint_id[*]) : null
}
output "subnet_id" {
  description = "Created Network Firewall subnet id"
  value       = var.enable_aws_nfw ? flatten(aws_networkfirewall_firewall.network_firewall[0].firewall_status[*].sync_states[*].attachment[*])[*].subnet_id : null
}

output "sync_states" {
  description = "Created Network Firewall states"
  value       = var.enable_aws_nfw ? (aws_networkfirewall_firewall.network_firewall[0].firewall_status[*].sync_states[*]) : null
}

output "attachment" {
  description = "Created Network Firewall states"
  value       = var.enable_aws_nfw ? (aws_networkfirewall_firewall.network_firewall[0].firewall_status[*].sync_states[*].attachment[*]) : null
}



