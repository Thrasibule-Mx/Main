# mx/thrasibule/universe/terragrunt.hcl
# =====================================
terraform_binary = format("%s/.local/bin/terraform", get_parent_terragrunt_dir())
