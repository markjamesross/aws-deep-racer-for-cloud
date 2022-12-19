variable "repository_name" {
  type        = string
  default     = "aws-deep-racer-for-cloud"
  description = "Name of the repo, used for splitting out tags"
}
variable "aws_region" {
  type        = string
  default     = "eu-west-1"
  description = "AWS region to use"
}
variable "instance_type" {
  type = string
  default     = "g4dn.2xlarge"
  #default     = "c5.2xlarge"
  description = "EC2 instance type to use for AWS Deep Racer for Cloud.  You need to ensure your quotas support intended usage"
}