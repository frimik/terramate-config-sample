output "ssm_names" {
  description = "Map of Trust Anchor root CA key and crt SSM parameter names"
  value = {
    crt = aws_ssm_parameter.this_crt.name
    key = aws_ssm_parameter.this_key.name
  }
}

output "cert_pem" {
  description = "Linkerd trust anchor certificate"
  value = trimspace(tls_self_signed_cert.this.cert_pem)
}
