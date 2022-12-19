module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket_prefix                         = "deepracer-for-cloud-local-"
  acl                                   = "private"
  attach_deny_insecure_transport_policy = true
  block_public_acls                     = true
  block_public_policy                   = true
  force_destroy                         = true
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

resource "aws_s3_object" "object" {
  for_each = fileset("${path.module}/../deep-racer-model", "*")
  bucket   = module.s3_bucket.s3_bucket_id
  key      = "custom_files/${each.key}"
  source   = "${path.module}/../deep-racer-model/${each.key}"
}

module "s3_bucket_upload" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket_prefix                         = "deepracer-for-cloud-upload-"
  acl                                   = "private"
  attach_deny_insecure_transport_policy = true
  block_public_acls                     = true
  block_public_policy                   = true
  force_destroy                         = true
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
      }
    }
  }
}
