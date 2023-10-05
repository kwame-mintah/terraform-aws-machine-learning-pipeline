# GitHub Action ---------------------------------
# -----------------------------------------------

locals {
  common_tags = merge(
    var.tags
  )
  create_inline_policy = (length(var.s3_bucket) > 0)
}

data "aws_caller_identity" "current_caller_identity" {}

#------------------------------------------------
# IAM Role
#------------------------------------------------
resource "aws_iam_role" "github_action_role" {
  name               = "AWSGitHubAction"
  path               = "/github/"
  assume_role_policy = data.aws_iam_policy_document.oidc_assume_policy.json

  tags = merge(
    local.common_tags,
  )

  depends_on = [aws_iam_openid_connect_provider.github_openid_connect]
}

data "aws_iam_policy_document" "oidc_assume_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current_caller_identity.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_repository}:ref:${var.github_branch}"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "s3_bucket_inline_policy" {
  count      = local.create_inline_policy ? 1 : 0
  role       = aws_iam_role.github_action_role.name
  policy_arn = aws_iam_policy.s3_put_object_policy[0].arn
}

resource "aws_iam_policy" "s3_put_object_policy" {
  count  = local.create_inline_policy ? 1 : 0
  name   = "s3-github-put-object"
  policy = data.aws_iam_policy_document.s3_put_object_policy_document[0].json

  tags = merge(
    local.common_tags,
  )
}

data "aws_iam_policy_document" "s3_put_object_policy_document" {
  count = local.create_inline_policy ? 1 : 0
  statement {
    sid = "AWSGitHubS3PutObject"
    actions = [
      "s3:PutObject",
    ]
    effect    = "Allow"
    resources = var.s3_bucket
  }
}

#------------------------------------------------
# GitHub OpenID Connect Provider
#------------------------------------------------
# https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#adding-the-identity-provider-to-aws
resource "aws_iam_openid_connect_provider" "github_openid_connect" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = ["cf23df2207d99a74fbe169e3eba035e633b65d94"]

  tags = merge(
    local.common_tags,
  )
}
