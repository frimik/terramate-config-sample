globals {
  providers = ["aws", "datadog"]

  aws_accounts = {
    crp = {
      alias = "root"
    }
    int = {
      alias = "cluster"
    }

    prd = {
      region = "us-east-1"
      alias = "foo"
    }
  }
}

globals "terraform" "providers" "aws" {
  version = "6.66.0"
}
