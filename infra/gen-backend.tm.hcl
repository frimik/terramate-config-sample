# Generate '_terramate_generated_backend.tf' in each stack
# All globals will be replaced with the final value that is known by the stack
# Any terraform code can be defined within the content block
generate_hcl "_terramate_generated_backend.tf" {
  condition = tm_contains(tm_keys(global), "backend")
  content {
    terraform {
      backend "s3" {
        bucket         = global.backend.bucket
        key            = global.backend.key
        region         = global.backend.region
        encrypt        = true
        dynamodb_table = global.backend.dynamodb_table
        role_arn       = global.backend.assume_role_arn
      }
    }
  }
}
