variable "cluster_name" {
  type = string
}

variable "ssm_names" {
  type = object({
    key = string
    crt = string
    }
  )
  default = {
    key = "/infra/linkerd/trust-anchor-root/tls.key"
    crt = "/infra/linkerd/trust-anchor-root/tls.crt"
  }
}

variable "webhook_issuer_local_file_path" {
  description = "Write the webhook issuer cert file locally to this path"
  default = ""
  type = string
}