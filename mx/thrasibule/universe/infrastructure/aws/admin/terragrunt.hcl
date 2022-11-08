# mx/thrasibule/universe/aws/admin/terragrunt.hcl
# ===============================================
include "root" {
    path = find_in_parent_folders()
}

include "provider" {
    path = find_in_parent_folders("provider.hcl")
}
