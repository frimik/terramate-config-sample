data "aws_ssm_parameter" "root_key" {
  name = var.ssm_names.key
  provider = aws.root
}

data "aws_ssm_parameter" "root_crt" {
  name = var.ssm_names.crt
  provider = aws.root
}
