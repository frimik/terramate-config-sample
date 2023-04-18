generate_file "_terramate_generated_providers_datadog.tf" {
  condition = tm_contains(global.providers, "datadog")
  content   = <<-EOT
    // TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT
    data "aws_ssm_parameter" "datadog_api_key" {
      ${tm_contains(tm_keys(tm_try(global.default_aws_account, {})), "crp") ? "" : "provider = aws.crp"~}

      name     = "${global.datadog.api_key_ssm_path}"
    }

    data "aws_ssm_parameter" "datadog_app_key" {
      ${tm_contains(tm_keys(tm_try(global.default_aws_account, {})), "crp") ? "" : "provider = aws.crp"~}

      name     = "${global.datadog.app_key_ssm_path}"
    }

    provider "datadog" {
      api_key = data.aws_ssm_parameter.datadog_api_key.value
      app_key = data.aws_ssm_parameter.datadog_app_key.value
    }
  EOT
}
