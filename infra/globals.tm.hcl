# file: terraform/infra/globals.tm.hcl
globals {

  terraform_version      = "~> 1.3.2"
  operator_aws_account   = {}
  aws_accounts           = {}
  default_aws_account    = { bogus = {} } // Explicitly set to a default bogus account in order to not "surprise" piggy-backing on the user's locally configured AWS profile
  providers              = ["aws"]
  default_gitlab_account = { gitlabadmin = {} }
  gitlab_accounts        = {}

  // data "export" - ie, write local files to a predetermined library (inclusion) path:
  ff_exports_data      = false
  ff_exports_data_path = "${terramate.stack.path.to_root}/lib/data"





  /*
  # The default Terraform version - override in stacks if you must
  terraform_version = "~> 1.3.2"
  */

  /* 
  # A special account profile, potentially needed for operators to create basic resources across our accounts, like cross-account IAM roles etc.
  # Primarily it excludes the assume_role_arn configuration and let's _you_ get direct access via _your_ assumed role.
  #
  operator_aws_account = {
    crp = {}
  }
  */

  /*  
  # Choose which extra aliased aws_accounts you want to work with by setting this to either or all of 'crp', 'int', 'prd'.
  # Optionally overriding 'region', 'role' or 'alias'.
  aws_accounts = {
    crp = {
      region = "eu-west-1"
      role = "infra/terraformer"
      alias = "root"
    }
    int = {
      alias = "cluster"
    }
  }
  */

  /*
  # Choose a default (unaliased) aws account for your stack with default_aws_account
    default_aws_account = {
      bogus = {
        region = "eu-north-1"           # optional
        role = "infra/terraformer" # optional
      }
    }
  */
  // Explicitly set to a bogus default to avoid "transparently" piggy-backing on user session provider.
  // Override by setting default_aws_account = unset in your stacks to remove the unaliased AWS provider entirely.
  // This should be properly overridden in the subfolders such as 'crp', 'int', 'prd'

  /*
  # Which providers to use, we assume you're always using aws.
  # You can choose from the following preconfigured providers:
  # aws, datadog, helm, kubernetes, mysql, postgresql, tls
  providers = ["aws"]
  */

  /*
  # base_url lookup hierarchy is: 1. values(default_gitlab_account)[0].base_url, 2. gitlab.account_map[accountname].base_url, 3. terraform.providers.gitlab.base_url
  # Override if you want a different default provider credential in your stack.
  # token_ssm_path has 2 lookup levels in the hierarchy. 1 and 2 above (but with token_ssm_path instead of base_url).
  # OVERRIDE: Choose a default GitLab Account by:
  default_gitlab_account = {
    gitlabadmin = {}
  }
  */

  # You can select any number of aliased gitlab providers to activate from the map here or add "extra" previously unmapped providers:
  #
  # gitlab_accounts = {
  #   mapped_account = {} # just select, no override
  #   unmapped_account = {
  #     token_ssm_path = "/path/to/my/unmapped/gitlab/access_token"
  #     base_url = "https://gitlab.example.com/api/v4/"
  #   }
  # }

  # Various "feature" flags

  /*
  # Whether the Stack is interested in exporting data to the /lib/data structure.
  # If set to true, will get a local.data_path variable set to the proper relative path
  ff_exports_data      = false
  ff_exports_data_path = "${terramate.stack.path.to_root}/lib/data"
  */

}

assert {
  assertion = tm_length(tm_keys(tm_try(global.default_aws_account, {}))) <= 1
  message   = "'default_aws_account' global can not contain more than one single account"
}

