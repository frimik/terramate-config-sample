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
    common_name         = "root.linkerd.cluster.local"
    country             = ""
    locality            = ""
    organization        = ""
    organizational_unit = ""
    postal_code         = ""
    province            = ""
    serial_number       = ""
    street_address      = []
  }

  validity_period_hours = 24 * 365 * 10 // 10 years

}

resource "aws_ssm_parameter" "this_key" {
  name        = "/infra/linkerd/trust-anchor-root/tls.key"
  description = format("Linkerd Trust Anchor mTLS root certificate key: %s/%s", tls_private_key.this.algorithm, tls_private_key.this.ecdsa_curve)
  type        = "SecureString"
  value       = tls_private_key.this.private_key_pem
}

resource "aws_ssm_parameter" "this_crt" {
  name        = "/infra/linkerd/trust-anchor-root/tls.crt"
  description = format("Linkerd Trust Anchor mTLS root certificate: %s. Expiration: %s", tls_self_signed_cert.this.subject[0].common_name, tls_self_signed_cert.this.validity_end_time)
  type        = "String"
  value       = trimspace(tls_self_signed_cert.this.cert_pem)
}

// Place it in ACM for optics and monitoring
resource "aws_acm_certificate" "this" {
  private_key      = tls_private_key.this.private_key_pem
  certificate_body = tls_self_signed_cert.this.cert_pem

  tags = {
    Name        = tls_self_signed_cert.this.subject[0].common_name
    Description = format("Find the certificate in Parameter Store: %s", aws_ssm_parameter.this_crt.name)
  }

}
