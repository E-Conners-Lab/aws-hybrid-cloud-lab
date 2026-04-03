# ------------------------------------------------------------------------------
# Hub / Transit VPC Subnets
# ------------------------------------------------------------------------------

resource "aws_subnet" "hub_tgw_1a" {
  vpc_id            = aws_vpc.hub.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zones[0]

  tags = {
    Name    = "hub-tgw-subnet-1a"
    Project = var.project_name
  }
}

resource "aws_subnet" "hub_tgw_1b" {
  vpc_id            = aws_vpc.hub.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.availability_zones[1]

  tags = {
    Name    = "hub-tgw-subnet-1b"
    Project = var.project_name
  }
}

# ------------------------------------------------------------------------------
# Shared Services VPC Subnets
# ------------------------------------------------------------------------------

resource "aws_subnet" "shared_private_1a" {
  vpc_id            = aws_vpc.shared.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = var.availability_zones[0]

  tags = {
    Name    = "shared-private-1a"
    Project = var.project_name
  }
}

resource "aws_subnet" "shared_private_1b" {
  vpc_id            = aws_vpc.shared.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = var.availability_zones[1]

  tags = {
    Name    = "shared-private-1b"
    Project = var.project_name
  }
}

# ------------------------------------------------------------------------------
# PCI VPC Subnets (3 tiers x 2 AZs)
# ------------------------------------------------------------------------------

resource "aws_subnet" "pci_nlb_1a" {
  vpc_id            = aws_vpc.pci.id
  cidr_block        = "10.2.1.0/24"
  availability_zone = var.availability_zones[0]

  tags = {
    Name    = "pci-nlb-1a"
    Project = var.project_name
    Tier    = "nlb"
  }
}

resource "aws_subnet" "pci_nlb_1b" {
  vpc_id            = aws_vpc.pci.id
  cidr_block        = "10.2.2.0/24"
  availability_zone = var.availability_zones[1]

  tags = {
    Name    = "pci-nlb-1b"
    Project = var.project_name
    Tier    = "nlb"
  }
}

resource "aws_subnet" "pci_app_1a" {
  vpc_id            = aws_vpc.pci.id
  cidr_block        = "10.2.3.0/24"
  availability_zone = var.availability_zones[0]

  tags = {
    Name    = "pci-app-1a"
    Project = var.project_name
    Tier    = "app"
  }
}

resource "aws_subnet" "pci_app_1b" {
  vpc_id            = aws_vpc.pci.id
  cidr_block        = "10.2.4.0/24"
  availability_zone = var.availability_zones[1]

  tags = {
    Name    = "pci-app-1b"
    Project = var.project_name
    Tier    = "app"
  }
}

resource "aws_subnet" "pci_data_1a" {
  vpc_id            = aws_vpc.pci.id
  cidr_block        = "10.2.5.0/24"
  availability_zone = var.availability_zones[0]

  tags = {
    Name    = "pci-data-1a"
    Project = var.project_name
    Tier    = "data"
  }
}

resource "aws_subnet" "pci_data_1b" {
  vpc_id            = aws_vpc.pci.id
  cidr_block        = "10.2.6.0/24"
  availability_zone = var.availability_zones[1]

  tags = {
    Name    = "pci-data-1b"
    Project = var.project_name
    Tier    = "data"
  }
}

# ------------------------------------------------------------------------------
# Management VPC Subnets
# ------------------------------------------------------------------------------

resource "aws_subnet" "mgmt_private_1a" {
  vpc_id            = aws_vpc.mgmt.id
  cidr_block        = "10.3.1.0/24"
  availability_zone = var.availability_zones[0]

  tags = {
    Name    = "mgmt-private-1a"
    Project = var.project_name
  }
}

resource "aws_subnet" "mgmt_private_1b" {
  vpc_id            = aws_vpc.mgmt.id
  cidr_block        = "10.3.2.0/24"
  availability_zone = var.availability_zones[1]

  tags = {
    Name    = "mgmt-private-1b"
    Project = var.project_name
  }
}
