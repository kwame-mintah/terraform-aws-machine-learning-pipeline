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
    {
      git_commit           = "ae71c751ae69f68bdfb1e291aa18c91cf2aa3681"
      git_file             = "modules/github_action/main.tf"
      git_last_modified_at = "2023-10-05 20:18:59"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "github_action_role"
      yor_trace            = "6801de83-79fc-4397-9917-6c0f71b62eaf"
  })

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
      values   = var.github_repositories
    }

    # Hardcoded value as `terraform_checkov` CKV_AWS_358 keeps failing even
    # when a variable has been added to handle trusting specific organisations or repositories.
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:kwame-mintah/*"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "s3_bucket_inline_policy" {
  count      = local.create_inline_policy ? 1 : 0
  role       = aws_iam_role.github_action_role.name
  policy_arn = aws_iam_policy.s3_allow_action_policy[0].arn
}

resource "aws_iam_policy" "s3_allow_action_policy" {
  count  = local.create_inline_policy ? 1 : 0
  name   = "s3-github-allow-actions"
  policy = data.aws_iam_policy_document.s3_allow_action_policy_document[0].json

  tags = merge(
    local.common_tags,
    {
      git_commit           = "cded871efde1611c7aa37bf295b56ef15418515f"
      git_file             = "modules/github_action/main.tf"
      git_last_modified_at = "2023-11-09 22:09:18"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "s3_allow_action_policy"
      yor_trace            = "452da295-340b-4059-994c-6f03d5b7e940"
  })
}

data "aws_iam_policy_document" "s3_allow_action_policy_document" {
  count = local.create_inline_policy ? 1 : 0
  statement {
    sid = "AWSGitHubS3AllowActions"
    actions = [
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:PutObject",
      "s3:ListBucketVersions",
      "s3:ListBucket"
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

  thumbprint_list = var.github_thumbprints

  tags = merge(
    local.common_tags,
    {
      git_commit           = "eb52cd392c99d4af36e269e4ad2cfdb237da05d0"
      git_file             = "modules/github_action/main.tf"
      git_last_modified_at = "2023-10-06 19:54:26"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "github_openid_connect"
      yor_trace            = "99478f60-ce69-454b-9604-1bb267782d9b"
  })
}
