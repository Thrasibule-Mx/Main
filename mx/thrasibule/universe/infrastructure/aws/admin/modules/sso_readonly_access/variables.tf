# mx/thrasibule/universe/aws/admin/modules/sso_readonly_access/variables.tf
# =========================================================================
variable "sso_accounts" {
    type = set(string)
    description = <<EOS
The list of AWS account identifiers on which to allow read-only access.
EOS
}

variable "sso_principal_id" {
    type = string
    description = <<EOS
The identifier of the user or group which is allowed to read-only access to the
organization.
EOS
    # SSO Group: TMXReadOnlyAdministrators
    default = "9367048bc1-c4d62d0f-2cab-4b58-9d14-89813ac60919"

    validation {
        condition = (
            length(var.sso_principal_id) >= 36
            && length(var.sso_principal_id) <= 47
            && can(regex(
                "^([0-9a-f]{10}-|)[A-Fa-f0-9]{8}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{12}$",
                var.sso_principal_id
            ))
        )
        error_message = "PrincipalIds are GUIDs (For example, f81d4fae-7dec-11d0-a765-00a0c91e6bf6)."
    }
}

variable "sso_principal_type" {
    type = string
    description = "The type of the provided identity."
    default = "GROUP"

    validation {
        condition = contains(["USER", "GROUP"], var.sso_principal_type)
        error_message = "Must be one of 'USER' or 'GROUP'."
    }
}

variable "prefix" {
    type = string
    description = "A value prepended to each created resources."
    default = "TMXReadOnly"

    validation {
        condition = (
            length(var.prefix) >= 0
            && length(var.prefix) < 128
            && can(regex("^[\\w-]*$", var.prefix))
        )
        error_message = "Must be a string of characters consisting of upper and lowercase alphanumeric characters, dash (-) and underscore (_) with no spaces."
    }
}
