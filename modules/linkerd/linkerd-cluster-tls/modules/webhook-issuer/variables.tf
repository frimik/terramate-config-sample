variable "cluster_name" {
  type = string
}

variable "webhook_issuer_local_file_path" {
  description = "Write the webhook issuer cert file locally to this path"
  default = ""
  type = string
}