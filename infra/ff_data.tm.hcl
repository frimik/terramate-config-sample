generate_hcl "_terramate_generated_ff_data.tf" {
  condition = global.ff_exports_data
  content {
    locals {
      // This is the stack relative path to /lib/data
      // prefixed tm_ to ensure all terramate-generated locals have that uniqueness to them
      tm_data_path = global.ff_exports_data_path
    }
  }
}
