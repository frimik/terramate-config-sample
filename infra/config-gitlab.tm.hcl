# Gitlab mapping, do not modify in sub stacks:
globals "gitlab" "account_map" {
  gitlabadmin = {
    token_ssm_path = "/infra/service-accounts/gitlab/svc_gitlabadmin/access-tokens/infra-terraformer/access_token"
  }
  atlantis = {
    token_ssm_path = "/infra/service-accounts/gitlab/svc_atlantisbot/access-tokens/infra-terraformer/access_token"
  }
  gitlabdev = {
    token_ssm_path = "/infra/service-accounts/gitlab/svc_gitlabdev/access-tokens/infra-terraformer/access_token"
  }
}
