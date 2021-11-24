# mx/thrasibule/universe/aws/provider.hcl
# =======================================
locals {
    env = read_terragrunt_config("env.hcl")

    provider = "aws"
    aws_universe_account_id = "314637056362"

    tf_prefix = "TMXTerraform"
    tf_state_aws_region = "eu-west-1"
}

remote_state {
    backend = "s3"
    disable_init = true

    config = {
        bucket = "tmx-universe-tfstate"
        key = format(
            "%s/%s/terraform.tfstate",
            local.provider,
            path_relative_to_include()
        )
        region = local.tf_state_aws_region
        acl = "bucket-owner-full-control"
        encrypt = true
        dynamodb_table = "tfstate"
        role_arn = format(
            "arn:aws:iam::%s:role/tmx-service-role/TMXTerraformStateUpdateRole",
            local.aws_universe_account_id
        )
        external_id = base64encode(
            join(
                "_",
                [local.tf_prefix, local.provider, local.aws_universe_account_id]
            )
        )
    }

    generate = {
        if_exists = "overwrite_terragrunt"
        path = "backend.tf"
    }
}

generate "terraform" {
    if_exists = "overwrite_terragrunt"
    path = "terraform.tf"
    contents = <<EOG
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.66.0"
        }
    }
}
EOG
}

generate "provider" {
    if_exists = "overwrite_terragrunt"
    path = "provider.tf"
    contents = <<EOG
provider "aws" {
    region = "${local.env.locals.aws_region}"
    assume_role {
        role_arn = "${
            join(
                ":",
                [
                    "arn:aws:iam:",
                    "${local.env.locals.aws_account_id}",
                    "role/tmx-service-role/TMXTerraformAdministrationRole"
                ]
            )
        }"
        external_id = "${
            base64encode(
                join(
                    "_",
                    [
                        "${local.tf_prefix}",
                        "${local.provider}",
                        "${local.env.locals.aws_account_id}"
                    ]
                )
            )
        }"
    }
    allowed_account_ids = [
        "${local.env.locals.aws_account_id}"
    ]
}

data "aws_partition" "self" {}
data "aws_caller_identity" "self" {}
EOG
}
