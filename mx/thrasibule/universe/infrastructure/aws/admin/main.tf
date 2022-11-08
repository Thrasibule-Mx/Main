# mx/thrasibule/universe/aws/admin/main.tf
# ========================================
locals {
    aws_accounts = {
        admin = "479518259644"
        audit = "157082376293"
        id = "276324087202"
        logging = "688842018105"
        sandbox = "386068839781"
        security = "456957523240"
        universe = "314637056362"
        v25c = "149334242673"
    }
}

module "sso_readonly_access" {
    source = "./modules/sso_readonly_access"
    sso_accounts = values(local.aws_accounts)
}
