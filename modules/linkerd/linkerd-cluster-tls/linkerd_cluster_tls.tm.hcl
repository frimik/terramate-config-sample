globals {
  providers       = ["aws", "tls"]

  ff_exports_data = true
}

generate_hcl "_terramate_generated_linkerd_cluster_tls.tf" {
  content {

    module "cluster_tls" {
      source = "${terramate.stack.path.to_root}/modules/linkerd/linkerd-cluster-tls"

      providers = {
        aws.cluster = aws.cluster
        aws.root    = aws.root
      }

      cluster_name = var.cluster_name

      webhook_issuer_local_file_path = "${path.root}/${local.tm_data_path}/linkerd-cluster-tls/${var.cluster_name}/webhook_issuer.pem"
    }

    variable "cluster_name" {
      type = string
    }

  }
}
