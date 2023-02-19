# Create Firewall

resource "aws_networkfirewall_firewall" "network_firewall" {
  name = "example-firewall"
  vpc_id = "vpc-0b6f28f8eb88d1b4f"
}

# Create Firewall policy

resource "aws_networkfirewall_firewall_policy" "network_firewall_policy1" {
  name = "firstpolicy"
  firewall_policy {
    stateful_default_actions = [ "aws:pass" ]
  }
}


