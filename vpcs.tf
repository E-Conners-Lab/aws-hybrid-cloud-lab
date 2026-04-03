# ------------------------------------------------------------------------------
# VPCs
# ------------------------------------------------------------------------------

resource "aws_vpc" "hub" {
  cidr_block           = var.vpcs.hub.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = var.vpcs.hub.name
    Project = var.project_name
  }
}

resource "aws_vpc" "shared" {
  cidr_block           = var.vpcs.shared.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = var.vpcs.shared.name
    Project = var.project_name
  }
}

resource "aws_vpc" "pci" {
  cidr_block           = var.vpcs.pci.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = var.vpcs.pci.name
    Project = var.project_name
  }
}

resource "aws_vpc" "mgmt" {
  cidr_block           = var.vpcs.mgmt.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = var.vpcs.mgmt.name
    Project = var.project_name
  }
}
