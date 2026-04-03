# AWS Hybrid Cloud Lab

Terraform project that deploys a multi-VPC hybrid cloud architecture on AWS, designed for a logistics company requiring PCI-DSS network segmentation. Uses a hub-and-spoke topology with AWS Transit Gateway for centralized routing and strict inter-VPC isolation.

## Architecture

```
                        ┌─────────────────────┐
                        │   Transit Gateway    │
                        │   (logistics-tgw)    │
                        └──┬─────┬─────┬────┬─┘
                           │     │     │    │
              ┌────────────┘     │     │    └────────────┐
              │                  │     │                 │
     ┌────────▼────────┐ ┌──────▼─────▼──┐   ┌─────────▼────────┐
     │   Hub/Transit   │ │    Shared     │   │   Management     │
     │   10.0.0.0/16   │ │   Services    │   │   10.3.0.0/16    │
     │                 │ │  10.1.0.0/16  │   │                  │
     └─────────────────┘ └───────────────┘   └──────────────────┘
                                │
                         ┌──────▼──────┐
                         │  PCI Zone   │
                         │ 10.2.0.0/16 │
                         │             │
                         │ ┌─────────┐ │
                         │ │   NLB   │ │
                         │ ├─────────┤ │
                         │ │   App   │ │
                         │ ├─────────┤ │
                         │ │  Data   │ │
                         │ └─────────┘ │
                         └─────────────┘
```

### VPCs

| VPC | CIDR | Purpose |
|-----|------|---------|
| Hub/Transit | `10.0.0.0/16` | Central routing hub and TGW attachment point |
| Shared Services | `10.1.0.0/16` | Common services (DNS, logging, monitoring) |
| PCI | `10.2.0.0/16` | Cardholder data environment with 3-tier isolation |
| Management | `10.3.0.0/16` | Administrative and operations tooling |

### Network Segmentation

Three Transit Gateway route tables enforce isolation:

- **Hub** — Full mesh. The only VPC that can reach all others.
- **General** (Shared Services, Management) — Can reach hub, shared, and mgmt. **Cannot reach PCI.**
- **PCI** — Can reach hub and shared services only. **Cannot reach Management.**

Default route table association and propagation are disabled on the TGW — all routing is explicit via static routes.

### Subnets

All VPCs span two availability zones (`us-east-1a`, `us-east-1b`). The PCI VPC uses a 3-tier subnet layout (NLB, App, Data) for compliance zoning. All subnets are `/24`.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- AWS credentials configured (via environment variables, `~/.aws/credentials`, or IAM role)
- Sufficient IAM permissions to create VPCs, subnets, and Transit Gateway resources

## Usage

```bash
# Initialize Terraform providers
terraform init

# Preview infrastructure changes
terraform plan

# Deploy the architecture
terraform apply

# Tear down all resources
terraform destroy
```

## Configuration

Key variables can be overridden in a `terraform.tfvars` file or via `-var` flags:

| Variable | Default | Description |
|----------|---------|-------------|
| `aws_region` | `us-east-1` | AWS region for all resources |
| `project_name` | `logistics-hybrid` | Project name used for resource tagging |
| `availability_zones` | `["us-east-1a", "us-east-1b"]` | AZs for subnet deployment |
| `vpcs` | See `variables.tf` | VPC CIDR and name definitions |

## Outputs

| Output | Description |
|--------|-------------|
| `vpc_ids` | Map of VPC IDs (hub, shared, pci, mgmt) |
| `transit_gateway_id` | Transit Gateway ID |
| `route_table_ids` | Map of TGW route table IDs (hub, general, pci) |

## License

This project is for educational and lab purposes.
