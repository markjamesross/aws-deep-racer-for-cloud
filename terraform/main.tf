provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      SourceCode     = element(split("/${var.repository_name}/", path.cwd), 1)
      DeploymentTool = "Terraform"
      Project        = "DeepRacerForCloud"
    }
  }
}