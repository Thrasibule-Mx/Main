# mx/thrasibule/universe/aws/admin/modules/sso_readonly_access/main.tf
# ====================================================================
data "aws_ssoadmin_instances" "self" {}

resource "aws_ssoadmin_permission_set" "readonly" {
    name = format("%sAccess", var.prefix)
    description = "Allow read-only administrative access."
    instance_arn = tolist(data.aws_ssoadmin_instances.self.arns)[0]
    session_duration = "PT1H"
}

resource "aws_ssoadmin_managed_policy_attachment" "readonly" {
    instance_arn = tolist(data.aws_ssoadmin_instances.self.arns)[0]
    permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
    managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_ssoadmin_account_assignment" "sso_readonly" {
    for_each = var.sso_accounts

    instance_arn = tolist(data.aws_ssoadmin_instances.self.arns)[0]
    permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
    principal_id = var.sso_principal_id
    principal_type = var.sso_principal_type
    target_id = each.key
    target_type = "AWS_ACCOUNT"
}
