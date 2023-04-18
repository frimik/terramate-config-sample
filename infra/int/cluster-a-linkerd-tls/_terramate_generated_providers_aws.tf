// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT    
# This is the default (unaliased) provider: "int"
provider "aws" {
  region = "eu-west-1"
  assume_role {
    role_arn = "arn:aws:iam::123456789954:role/infra/terraformer"
  }
  allowed_account_ids = [123456789954]

  default_tags {
    tags = {
      TerraformRoot = "infra/int/cluster-a-linkerd-tls"
    }
  }
}

provider "aws" {
  alias = "crp"
  region = "eu-north-1"
  assume_role {
    role_arn = "arn:aws:iam::123456789829:role/infra/terraformer"
  }
  allowed_account_ids = [123456789829]

  default_tags {
    tags = {
      TerraformRoot = "infra/int/cluster-a-linkerd-tls"
    }
  }
}

provider "aws" {
  alias = "cluster"
  region = "eu-west-1"
  assume_role {
    role_arn = "arn:aws:iam::123456789954:role/infra/terraformer"
  }
  allowed_account_ids = [123456789954]

  default_tags {
    tags = {
      TerraformRoot = "infra/int/cluster-a-linkerd-tls"
    }
  }
}

provider "aws" {
  alias = "foo"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::123456789303:role/infra/terraformer"
  }
  allowed_account_ids = [123456789303]

  default_tags {
    tags = {
      TerraformRoot = "infra/int/cluster-a-linkerd-tls"
    }
  }
}
