terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

// Create a linkerd CA key identical to what step creates.
resource "tls_private_key" "this" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "this" {

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]

  is_ca_certificate = true
  private_key_pem   = tls_private_key.this.private_key_pem

  subject {
    common_name = "webhook.linkerd.cluster.local"

    # required on tls provider upgrade to 4.0.x to avoid replacement of the resource
    # FIXME: https://github.com/hashicorp/terraform-provider-tls/issues/284
    country             = ""
    locality            = ""
    organization        = ""
    organizational_unit = ""
    postal_code         = ""
    province            = ""
    serial_number       = ""
    street_address      = null
  }

  validity_period_hours = 24 * 365 * 10 // 10 years

}

resource "aws_ssm_parameter" "this_key" {
  name        = format("/infra/linkerd/clusters/%s/webhook-issuer/tls.key", var.cluster_name)
  description = format("Linkerd Webhook CA certificate key for %s: %s/%s", var.cluster_name, tls_private_key.this.algorithm, tls_private_key.this.ecdsa_curve)
  type        = "SecureString"
  value       = tls_private_key.this.private_key_pem
}

resource "aws_ssm_parameter" "this_crt" {
  name        = format("/infra/linkerd/clusters/%s/webhook-issuer/tls.crt", var.cluster_name)
  description = format("Linkerd Webhook CA certificate for %s: %s. Expiration: %s", var.cluster_name, tls_self_signed_cert.this.subject[0].common_name, tls_self_signed_cert.this.validity_end_time)
  type        = "String"
  value       = trimspace(tls_self_signed_cert.this.cert_pem)
}

// Place it in ACM for optics and monitoring
resource "aws_acm_certificate" "this" {
  private_key      = tls_private_key.this.private_key_pem
  certificate_body = tls_self_signed_cert.this.cert_pem

  tags = {
    Name        = var.cluster_name
    Description = format("Find the certificate in Parameter Store: %s", aws_ssm_parameter.this_crt.name)
  }

}

// Write it to a local file if we're passed an explicit variable that points out where
resource "local_file" "webhook_issuer_crt" {
  count    = var.webhook_issuer_local_file_path != "" ? 1 : 0
  content  = trimspace(tls_self_signed_cert.this.cert_pem)
  filename = var.webhook_issuer_local_file_path
}
