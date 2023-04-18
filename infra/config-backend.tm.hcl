# define a bucket name that is used when generating backend.tf defined below
globals "backend" {
  bucket          = "infra-terraform"
  key             = tm_format("%s/terraform.tfstate", tm_substr(terramate.path, 1, -1))
  region          = "eu-north-1"
  dynamodb_table  = "infra-terraform-locks"
  assume_role_arn = "arn:aws:iam::123456789829:role/infra/terraformer"
}