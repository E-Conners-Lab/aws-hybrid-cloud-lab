variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for tagging"
  type        = string
  default     = "logistics-hybrid"
}

variable "vpcs" {
  description = "VPC definitions"
  type = map(object({
    cidr = string
    name = string
  }))
  default = {
    hub = {
      cidr = "10.0.0.0/16"
      name = "hub-transit-vpc"
    }
    shared = {
      cidr = "10.1.0.0/16"
      name = "shared-services-vpc"
    }
    pci = {
      cidr = "10.2.0.0/16"
      name = "pci-vpc"
    }
    mgmt = {
      cidr = "10.3.0.0/16"
      name = "management-vpc"
    }
  }
}

variable "availability_zones" {
  description = "AZs for subnet deployment"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
