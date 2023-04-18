globals {
  providers = ["aws", "datadog"]

  aws_accounts = {
    crp = {
      alias = "root"
    }
    int = {
      alias = "cluster"
    }
  }
}
