output "cert_pem" {
  description = "Linkerd webhook CA certificate"
  value = trimspace(tls_self_signed_cert.this.cert_pem)
}
