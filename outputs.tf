# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "vpc_ids" {
  description = "VPC IDs"
  value = {
    hub    = aws_vpc.hub.id
    shared = aws_vpc.shared.id
    pci    = aws_vpc.pci.id
    mgmt   = aws_vpc.mgmt.id
  }
}

output "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = aws_ec2_transit_gateway.main.id
}

output "route_table_ids" {
  description = "Transit Gateway Route Table IDs"
  value = {
    hub     = aws_ec2_transit_gateway_route_table.hub.id
    general = aws_ec2_transit_gateway_route_table.general.id
    pci     = aws_ec2_transit_gateway_route_table.pci.id
  }
}
