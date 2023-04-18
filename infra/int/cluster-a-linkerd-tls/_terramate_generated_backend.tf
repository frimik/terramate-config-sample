// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

terraform {
  backend "s3" {
    bucket         = "infra-terraform"
    dynamodb_table = "infra-terraform-locks"
    encrypt        = true
    key            = "infra/int/cluster-a-linkerd-tls/terraform.tfstate"
    region         = "eu-north-1"
    role_arn       = "arn:aws:iam::123456789829:role/infra/terraformer"
  }
}
