// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "cluster_tls" {
  cluster_name = var.cluster_name
  providers = {
    aws.cluster = aws.cluster
    aws.root    = aws.root
  }
  source                         = "../../../modules/linkerd/linkerd-cluster-tls"
  webhook_issuer_local_file_path = "${path.root}/${local.tm_data_path}/linkerd-cluster-tls/${var.cluster_name}/webhook_issuer.pem"
}
variable "cluster_name" {
  type = string
}
