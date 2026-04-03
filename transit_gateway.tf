# ------------------------------------------------------------------------------
# Transit Gateway
# ------------------------------------------------------------------------------

resource "aws_ec2_transit_gateway" "main" {
  description                     = "Hub for logistics company hybrid cloud design"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name    = "logistics-tgw"
    Project = var.project_name
  }
}

# ------------------------------------------------------------------------------
# VPC Attachments
# ------------------------------------------------------------------------------

resource "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = aws_vpc.hub.id
  subnet_ids         = [aws_subnet.hub_tgw_1a.id, aws_subnet.hub_tgw_1b.id]

  tags = {
    Name    = "hub-transit-attachment"
    Project = var.project_name
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "shared" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = aws_vpc.shared.id
  subnet_ids         = [aws_subnet.shared_private_1a.id, aws_subnet.shared_private_1b.id]

  tags = {
    Name    = "shared-services-attachment"
    Project = var.project_name
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "pci" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = aws_vpc.pci.id
  subnet_ids         = [aws_subnet.pci_nlb_1a.id, aws_subnet.pci_nlb_1b.id]

  tags = {
    Name    = "pci-attachment"
    Project = var.project_name
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "mgmt" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = aws_vpc.mgmt.id
  subnet_ids         = [aws_subnet.mgmt_private_1a.id, aws_subnet.mgmt_private_1b.id]

  tags = {
    Name    = "management-attachment"
    Project = var.project_name
  }
}

# ------------------------------------------------------------------------------
# Transit Gateway Route Tables
# ------------------------------------------------------------------------------

resource "aws_ec2_transit_gateway_route_table" "hub" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id

  tags = {
    Name    = "hub-rt"
    Project = var.project_name
  }
}

resource "aws_ec2_transit_gateway_route_table" "general" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id

  tags = {
    Name    = "general-rt"
    Project = var.project_name
  }
}

resource "aws_ec2_transit_gateway_route_table" "pci" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id

  tags = {
    Name    = "pci-rt"
    Project = var.project_name
  }
}

# ------------------------------------------------------------------------------
# Route Table Associations
# ------------------------------------------------------------------------------

resource "aws_ec2_transit_gateway_route_table_association" "hub" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.hub.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.hub.id
}

resource "aws_ec2_transit_gateway_route_table_association" "shared" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.shared.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.general.id
}

resource "aws_ec2_transit_gateway_route_table_association" "mgmt" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.mgmt.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.general.id
}

resource "aws_ec2_transit_gateway_route_table_association" "pci" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.pci.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.pci.id
}

# ------------------------------------------------------------------------------
# Static Routes — hub-rt (sees everything)
# ------------------------------------------------------------------------------

resource "aws_ec2_transit_gateway_route" "hub_to_shared" {
  destination_cidr_block         = var.vpcs.shared.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.shared.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.hub.id
}

resource "aws_ec2_transit_gateway_route" "hub_to_pci" {
  destination_cidr_block         = var.vpcs.pci.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.pci.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.hub.id
}

resource "aws_ec2_transit_gateway_route" "hub_to_mgmt" {
  destination_cidr_block         = var.vpcs.mgmt.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.mgmt.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.hub.id
}

# ------------------------------------------------------------------------------
# Static Routes — general-rt (no route to PCI)
# ------------------------------------------------------------------------------

resource "aws_ec2_transit_gateway_route" "general_to_hub" {
  destination_cidr_block         = var.vpcs.hub.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.hub.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.general.id
}

resource "aws_ec2_transit_gateway_route" "general_to_shared" {
  destination_cidr_block         = var.vpcs.shared.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.shared.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.general.id
}

resource "aws_ec2_transit_gateway_route" "general_to_mgmt" {
  destination_cidr_block         = var.vpcs.mgmt.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.mgmt.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.general.id
}

# NOTE: No route to 10.2.0.0/16 (PCI) — isolation by design

# ------------------------------------------------------------------------------
# Static Routes — pci-rt (no route to management)
# ------------------------------------------------------------------------------

resource "aws_ec2_transit_gateway_route" "pci_to_hub" {
  destination_cidr_block         = var.vpcs.hub.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.hub.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.pci.id
}

resource "aws_ec2_transit_gateway_route" "pci_to_shared" {
  destination_cidr_block         = var.vpcs.shared.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.shared.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.pci.id
}

# NOTE: No route to 10.3.0.0/16 (Management) — minimal access
