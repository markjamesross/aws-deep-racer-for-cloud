#Build basic VPC from public module with only public subnets to avoid cost of NAT gateways
#Wouldn't recommend this set-up for productive use
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "aws-deep-racer-cloud-vpc"
  cidr                 = "172.31.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  azs            = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b", "${data.aws_region.current.name}c"]
  public_subnets = ["172.31.0.0/24", "172.31.1.0/24", "172.31.2.0/24"]
}