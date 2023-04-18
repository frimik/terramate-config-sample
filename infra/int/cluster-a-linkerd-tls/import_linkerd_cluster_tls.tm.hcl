# This file is part of Terramate Configuration.
# Terramate is an orchestrator and code generator for Terraform.
# Please see https://github.com/mineiros-io/terramate for more information.
#
# To generate/update Terraform code within the stacks
# run `terramate generate` from root directory of the repository.

# This configuration triggers usage of "/modules/linkerd/linkerd-cluster-tls/linkerd_cluster_tls.tm.hcl"
# and demonstrate deduplication of code without using symlinks.

import {
  source = "/modules/linkerd/linkerd-cluster-tls/linkerd_cluster_tls.tm.hcl"
}
