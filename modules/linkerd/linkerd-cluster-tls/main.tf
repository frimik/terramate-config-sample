terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

      configuration_aliases = [aws.root, aws.cluster]
    }
  }
}

// Create a linkerd CA key identical to what step creates.
resource "tls_private_key" "this" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "this" {

  private_key_pem = tls_private_key.this.private_key_pem

  subject {
    common_name = "identity-ca.linkerd.cluster.local"

    # required on tls provider upgrade to 4.0.x to avoid replacement of the resource
    # FIXME: https://github.com/hashicorp/terraform-provider-tls/issues/284
    organization        = ""
    organizational_unit = ""
    country             = ""
    locality            = ""
    postal_code         = ""
    province            = ""
    serial_number       = ""
    street_address      = null
  }

}

resource "tls_locally_signed_cert" "this" {
  cert_request_pem   = tls_cert_request.this.cert_request_pem
  ca_private_key_pem = data.aws_ssm_parameter.root_key.value
  ca_cert_pem        = data.aws_ssm_parameter.root_crt.value

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]

  is_ca_certificate = true

  validity_period_hours = 24 * 365 * 2 // 2 years

}


resource "aws_ssm_parameter" "this_key" {
  name        = format("/infra/linkerd/clusters/%s/identity-ca/tls.key", var.cluster_name)
  description = format("Linkerd Cluster CA mTLS certificate key for %s: %s/%s.", var.cluster_name, tls_private_key.this.algorithm, tls_private_key.this.ecdsa_curve)
  type        = "SecureString"
  value       = tls_private_key.this.private_key_pem
  provider    = aws.cluster
}

resource "aws_ssm_parameter" "this_crt" {
  name        = format("/infra/linkerd/clusters/%s/identity-ca/tls.crt", var.cluster_name)
  description = format("Linkerd Cluster CA mTLS certificate for %s: %s. Signed by linkerd-trust-anchor root. Expiration: %s", var.cluster_name, tls_cert_request.this.subject[0].common_name, tls_locally_signed_cert.this.validity_end_time)
  type        = "String"
  value       = trimspace(tls_locally_signed_cert.this.cert_pem)
  provider    = aws.cluster
}

// Place the cluster issuer certificate in ACM for operator optics and monitoring
resource "aws_acm_certificate" "this" {
  private_key       = tls_private_key.this.private_key_pem
  certificate_body  = tls_locally_signed_cert.this.cert_pem
  certificate_chain = data.aws_ssm_parameter.root_crt.value

  tags = {
    Name        = var.cluster_name
    Description = format("Find the certificate in Parameter Store: %s", aws_ssm_parameter.this_crt.name)
  }

  provider = aws.cluster

}

module "webhook_issuer" {
  source = "./modules/webhook-issuer"

  cluster_name = var.cluster_name

  providers = {
    aws = aws.cluster
  }

  webhook_issuer_local_file_path = var.webhook_issuer_local_file_path

}
