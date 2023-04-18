output "cert_pem" {
  description = "Linkerd cluster issuer certificate"
  value = trimspace(tls_locally_signed_cert.this.cert_pem)
}

output "webhook_issuer_cert_pem" {
  description = "Linkerd webhook CA certificate"
  value = module.webhook_issuer.cert_pem
}
