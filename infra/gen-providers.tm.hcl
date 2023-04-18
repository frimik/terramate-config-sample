#generate_hcl "_terramate_generated_providers_aws.tf" {
#  condition = tm_contains(global.providers, "aws") || tm_contains(global.providers, "datadog")
#  content {
#    provider "aws" {
#      alias  = global.aws_account
#      region = tm_lookup(tm_lookup(global.aws.account_map, global.aws_account), "default_region")
#      assume_role {
#        role_arn = tm_lookup(tm_lookup(global.aws.account_map, global.aws_account), "assume_role_arn")
#      }
#      allowed_account_ids = [tm_lookup(tm_lookup(global.aws.account_map, global.aws_account), "account_id")]
#    }
#  }
#}

generate_file "_terramate_generated_providers_aws.tf" {
  condition = (tm_contains(global.providers, "datadog") || tm_contains(global.providers, "aws")) && (tm_length(tm_keys(global.aws_accounts)) > 0 || tm_length(tm_keys(global.operator_aws_account)) > 0 || tm_length(tm_keys(global.default_aws_account)) > 0)
  content   = <<-EOT
    // TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT%{for awsAccount, opts in tm_try(global.operator_aws_account, {})~}
    # This is the default (unaliased) provider for Operators with no role assumption.
    # This relies on the operators having the named profile configured themselves: "${awsAccount}"
    provider "aws" {
      region = "${tm_lookup(opts, "region", tm_lookup(tm_lookup(global.aws.account_map, awsAccount), "region"))}"
      profile = "${awsAccount}"
      allowed_account_ids = [${tm_lookup(tm_lookup(global.aws.account_map, awsAccount), "account_id")}]

      default_tags {
        tags = {
          TerraformRoot = "${terramate.stack.path.relative}"
        }
      }
    }
    %{endfor~}
    %{for awsAccount, opts in tm_try(global.default_aws_account, {})}
    # This is the default (unaliased) provider: "${awsAccount}"
    provider "aws" {
      region = "${tm_lookup(opts, "region", tm_lookup(tm_lookup(global.aws.account_map, awsAccount), "region"))}"%{if tm_length(tm_lookup(opts, "role", tm_lookup(tm_lookup(global.aws.account_map, awsAccount, ""), "role", ""), ), ) > 0}
      assume_role {
        role_arn = "${tm_format("arn:aws:iam::%s:role/%s", tm_lookup(tm_lookup(global.aws.account_map, awsAccount), "account_id"), tm_lookup(opts, "role", tm_lookup(tm_lookup(global.aws.account_map, awsAccount), "role")))}"
      }
      %{else}
      profile = "${tm_lookup(opts, "profile", tm_lookup(tm_lookup(global.aws.account_map, awsAccount, {}), "profile", awsAccount), )}"
      %{endif}allowed_account_ids = [${tm_lookup(tm_lookup(global.aws.account_map, awsAccount), "account_id")}]

      default_tags {
        tags = {
          TerraformRoot = "${terramate.stack.path.relative}"
        }
      }
    }
    %{endfor}%{for awsAccount, opts in tm_merge(global.aws_accounts, tm_contains(global.providers, "datadog") && !tm_contains(tm_keys(tm_try(global.default_aws_account, {})), "crp") ? {crp = {}} : {})}
    provider "aws" {
      alias = "${tm_lookup(opts, "alias", awsAccount)}"
      region = "${tm_lookup(opts, "region", tm_lookup(tm_lookup(global.aws.account_map, awsAccount), "region"))}"
      assume_role {
        role_arn = "${tm_format("arn:aws:iam::%s:role/%s", tm_lookup(tm_lookup(global.aws.account_map, awsAccount), "account_id"), tm_lookup(opts, "role", tm_lookup(tm_lookup(global.aws.account_map, awsAccount), "role")))}"
      }
      allowed_account_ids = [${tm_lookup(tm_lookup(global.aws.account_map, awsAccount), "account_id")}]

      default_tags {
        tags = {
          TerraformRoot = "${terramate.stack.path.relative}"
        }
      }
    }
    %{endfor~}
  EOT
}
