
locals {
    role_name   =   "CloudCustodian-ReadOnly"
    tags = merge(var.tags, {CreatedBy = "Terraform"})
}


data "aws_iam_policy_document" "sts-by-billing" {
  provider = aws.billing
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = var.assumed_by_principals
    }
  }
}

resource "aws_iam_role" "cloudcustodian" {
  provider = aws.billing
  name = local.role_name
  
  assume_role_policy = data.aws_iam_policy_document.sts-by-billing.json

  tags = {
    CreatedBy = "Terraform"
  }
}
