generate_file "_terramate_generated_versions.tf" {
  content = <<-EOT
    // TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT
    terraform {
      required_providers {
        %{for provider in global.providers}
        ${provider} = {
          source = "${tm_lookup(tm_lookup(global.terraform.providers, provider), "source")}"
          ${tm_contains(tm_keys(tm_lookup(global.terraform.providers, provider)), "version") ? "version = \"${tm_lookup(tm_lookup(global.terraform.providers, provider), "version")}\"" : ""~}

        }
        %{endfor}
      }
    }

    terraform {
      required_version = "${global.terraform_version}"
    }
  EOT
}
