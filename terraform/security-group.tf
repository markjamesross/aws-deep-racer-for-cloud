#Security Group with all outbound access
module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "aws-deep-racer-cloud-security-group"
  description = "Security group for AWS Deep Racer for Cloud"
  vpc_id      = module.vpc.vpc_id

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      description = "all out"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}