globals "aws" {
  account_map = {
    crp = {
      account_id = 123456789829
      role       = "infra/terraformer"
      region     = "eu-north-1"
    }
    int = {
      account_id = 123456789954
      role       = "infra/terraformer"
      region     = "eu-west-1"
    }
    prd = {
      account_id = 123456789303
      role       = "infra/terraformer"
      region     = "eu-west-1"
    }

    bogus = {
      account_id = 123456789012
      role       = "infra/bogus"
      region     = "bogus"
    }
  }

}