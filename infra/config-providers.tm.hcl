# file: terraform/infra/infra/config-providers.tm.hcl

/* Override specific providers as needed using labeled globals blocks:
  globals "terraform" "providers" "aws" {
    source = "my/aws"
    version = "4.36.0"
  }
*/

globals "terraform" "providers" {

  aws = {
    source  = "hashicorp/aws"
    version = "~> 4.38.0"
  }

  datadog = {
    source  = "datadog/datadog"
    version = ">= 3.18.0"
  }

  gitlab = {
    # Using fork: https://registry.terraform.io/providers/cloud-destroyer/gitlab/3.19.0-clouddestroyer
    # Because of: https://gitlab.com/gitlab-org/terraform-provider-gitlab/-/merge_requests/1363
    #source   = "gitlabhq/gitlab"
    #version  = "~> 3.19.0"
    source   = "cloud-destroyer/gitlab"
    version  = "3.19.0-clouddestroyer"
    base_url = "https://gitlab.example.com/api/v4/"
  }

  helm = {
    source  = "hashicorp/helm"
    version = "~> 2.7.1"
  }

  kubernetes = {
    source  = "hashicorp/kubernetes"
    version = ">= 2.14.0"
  }

  mysql = {
    source  = "petoju/mysql"
    version = "3.0.24"
  }

  postgresql = {
    source  = "cyrilgdn/postgresql"
    version = "1.17.1"
  }

  random = {
    source  = "hashicorp/random"
    version = "3.4.3"
  }

  tls = {
    source  = "hashicorp/tls"
    version = "~> 4.0.4"
  }

}

