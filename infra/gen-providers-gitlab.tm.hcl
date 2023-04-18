generate_file "_terramate_generated_providers_gitlab.tf" {
  condition = tm_contains(global.providers, "gitlab") && (tm_length(tm_keys(global.gitlab_accounts)) > 0 || tm_length(tm_keys(global.default_gitlab_account)) > 0)
  content   = <<-EOT
    // TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT
    %{for gitlabAccount, opts in tm_try(global.default_gitlab_account, {})}
    data "aws_ssm_parameter" "gitlab_token" {
      ${tm_contains(tm_keys(tm_try(global.default_aws_account, {})), "crp") ? "" : "provider = aws.crp"~}

      name = "${tm_lookup(tm_values(global.default_gitlab_account)[0], "token_ssm_path", tm_lookup(tm_lookup(global.gitlab.account_map, gitlabAccount), "token_ssm_path"))}"
    }
    # This is the default (unaliased) provider: "${gitlabAccount}"
    provider "gitlab" {
      base_url = "${tm_lookup(tm_values(global.default_gitlab_account)[0], "base_url", tm_lookup(tm_lookup(global.gitlab.account_map, gitlabAccount), "base_url", "${global.terraform.providers.gitlab.base_url}"))}"

      token = data.aws_ssm_parameter.gitlab_token.value
    }
    %{endfor}
    %{for gitlabAccount, opts in global.gitlab_accounts}
    data "aws_ssm_parameter" "gitlab_token_${tm_lookup(opts, "alias", gitlabAccount)}" {
      ${tm_contains(tm_keys(tm_try(global.default_aws_account, {})), "crp") ? "" : "provider = aws.crp"~}

      name = "${tm_lookup(opts, "token_ssm_path", tm_lookup(tm_lookup(global.gitlab.account_map, gitlabAccount), "token_ssm_path"))}"
    }
    provider "gitlab" {
      alias = "${tm_lookup(opts, "alias", gitlabAccount)}"
      base_url = "${tm_lookup(opts, "base_url", tm_lookup(tm_lookup(global.gitlab.account_map, gitlabAccount), "base_url", "${global.terraform.providers.gitlab.base_url}"))}"
      token = data.aws_ssm_parameter.gitlab_token_${tm_lookup(opts, "alias", gitlabAccount)}.value
    }
    %{endfor}
  EOT
}