#Find AMI to use
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}
#Use template file to create EC2 instance userdata
data "template_file" "userdata" {
  template = file("${path.module}/userdata/userdata.tpl")
  vars = {
    s3_bucket_local = module.s3_bucket.s3_bucket_id
    s3_bucket_upload = module.s3_bucket_upload.s3_bucket_id
  }
}
#Create EC2 instance from public module
module "ec2_instance" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 4.2.1"
  name                        = "aws-deep-racer-for-cloud-instance"
  ami                         = data.aws_ami.ubuntu.image_id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = element(module.vpc.public_subnets, 2)
  user_data                   = data.template_file.userdata.rendered
  ebs_optimized               = true
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = 50
    },
  ]
  create_spot_instance                = true
  spot_wait_for_fulfillment           = true
  spot_instance_interruption_behavior = "stop"
  create_iam_instance_profile         = true
  iam_role_name                       = "aws-deep-racer-for-cloud-role"
  iam_role_policies = {
    AmazonS3FullAccess                  = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    AmazonVPCReadOnlyAccess             = "arn:aws:iam::aws:policy/AmazonVPCReadOnlyAccess"
    AmazonKinesisVideoStreamsFullAccess = "arn:aws:iam::aws:policy/AmazonKinesisVideoStreamsFullAccess"
    CloudWatchFullAccess                = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
    AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 8
    instance_metadata_tags      = "enabled"
  }
}