// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT
data "aws_ssm_parameter" "datadog_api_key" {
  provider = aws.crp
  name     = "/infra/datadog/infra/api_key"
}

data "aws_ssm_parameter" "datadog_app_key" {
  provider = aws.crp
  name     = "/infra/datadog/infra-terraformer/app_key"
}

provider "datadog" {
  api_key = data.aws_ssm_parameter.datadog_api_key.value
  app_key = data.aws_ssm_parameter.datadog_app_key.value
}
