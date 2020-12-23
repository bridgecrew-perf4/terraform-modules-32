
locals {
    role_name   =   "CloudCustodian-AutoTag"
    tags = merge(var.tags, {CreatedBy = "Terraform"})
}


data "aws_iam_policy_document" "sts-by-billing" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = var.assumed_by_principals
    }
  }
}

data "aws_iam_policy_document" "tagging" {
  statement {
    actions = [
      "ec2:DeleteTags",
      "ec2:CreateTags",
    ]
    resources = [ "*" ]
    condition {
      test = "StringLike"
      variable = "aws:TagKeys"
      values = ["custodian:"]
    }
  }
}

resource "aws_iam_role" "cloudcustodian" {
  name = local.role_name
  assume_role_policy = data.aws_iam_policy_document.sts-by-billing.json
  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "readonly_attachment" {
  role = aws_iam_role.cloudcustodian.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_policy" "custodian_autotagging" {
  name  = "cloud-custodian-tagging"
  path  = "/"
  policy = data.aws_iam_policy_document.tagging.json
}

resource "aws_iam_role_policy_attachment" "tagging_attachment" {
  role = aws_iam_role.cloudcustodian.name
  policy_arn = aws_iam_policy.custodian_tagging.arn
}