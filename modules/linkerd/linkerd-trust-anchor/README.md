# linkerd-trust-anchor

Completely ignorant module which takes no parameters at all.

## Usage

```hcl
module "infra_lookup" {
  source = "../../../modules/infra/infra-lookup"
}

// Make crp our default
provider "aws" {
  region = "eu-north-1"
  assume_role {
    role_arn = module.infra_lookup.terraform.role_arns.crp
  }
}

module "linkerd_trust_anchor" {
  source = "../../../modules/infra/linkerd/linkerd-trust-anchor"
}

// The Linkerd Trust Anchor certificate is public information and is needed in all Linkerd installations 
resource "local_file" "crt" {
  content  = module.linkerd_trust_anchor.cert_pem
  filename = "${path.module}/data/linkerd_trust_anchor.pem"
}
```
