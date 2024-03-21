# GitHub Action ---------------------------------
# -----------------------------------------------

locals {
  common_tags = merge(
    var.tags
  )
  create_inline_s3_policy  = (length(var.s3_bucket) > 0)
  create_inline_ecr_policy = (length(var.ecr_repository) > 0)
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
      git_commit           = "94d4bea21b7f770d88610a210d2d2cbb551dabd3"
      git_file             = "modules/github_action/main.tf"
      git_last_modified_at = "2023-10-06 19:51:17"
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
    #checkov:skip=CKV_AWS_358:Specific Github Repo And Branch is recommended 
    # Using a wildcard (*) in token.actions.githubusercontent.com:sub can allow requests from more sources than you intended. 
    # Specify the value of token.actions.githubusercontent.com:sub with the repository and branch name.
    # https://docs.aws.amazon.com/IAM/latest/UserGuide/access-analyzer-reference-policy-checks.html#access-analyzer-reference-policy-checks-general-warning-specific-github-repo-and-branch-recommended
  }
}

resource "aws_iam_role_policy_attachment" "s3_bucket_inline_policy" {
  count      = local.create_inline_s3_policy ? 1 : 0
  role       = aws_iam_role.github_action_role.name
  policy_arn = aws_iam_policy.s3_allow_action_policy[0].arn
}

resource "aws_iam_policy" "s3_allow_action_policy" {
  count  = local.create_inline_s3_policy ? 1 : 0
  name   = "GitHubActionsAllowS3Access"
  policy = data.aws_iam_policy_document.s3_allow_action_policy_document[0].json

  tags = merge(
    local.common_tags,
    {
      git_commit           = "15f077acc384aadce4896fd9053f592b7d0d0345"
      git_file             = "modules/github_action/main.tf"
      git_last_modified_at = "2024-01-07 14:51:39"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "s3_allow_action_policy"
      yor_trace            = "452da295-340b-4059-994c-6f03d5b7e940"
  })
}

#trivy:ignore:AVD-AWS-0057
data "aws_iam_policy_document" "s3_allow_action_policy_document" {
  count = local.create_inline_s3_policy ? 1 : 0
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

resource "aws_iam_role_policy_attachment" "ecr_inline_policy" {
  count      = local.create_inline_ecr_policy ? 1 : 0
  role       = aws_iam_role.github_action_role.name
  policy_arn = aws_iam_policy.ecr_allow_action_policy[0].arn
}

resource "aws_iam_policy" "ecr_allow_action_policy" {
  count  = local.create_inline_ecr_policy ? 1 : 0
  name   = "GitHubActionsAllowECRAccess"
  policy = data.aws_iam_policy_document.ecr_allow_action_policy_document[0].json

  tags = merge(
    local.common_tags,
    {
      git_commit           = "8881e710653918737b2a5ec73174cead983aab02"
      git_file             = "modules/github_action/main.tf"
      git_last_modified_at = "2024-01-07 14:57:46"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "ecr_allow_action_policy"
      yor_trace            = "9818afb9-743f-4e35-88db-03ccecd7bcf2"
  })
}

#trivy:ignore:AVD-AWS-0057
data "aws_iam_policy_document" "ecr_allow_action_policy_document" {
  count = local.create_inline_ecr_policy ? 1 : 0
  statement {
    sid = "AWSGitHubECRAllowActions"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    effect    = "Allow"
    resources = var.ecr_repository
  }
  #checkov:skip=CKV_AWS_356:this is the minimum permissions needed to login and push
  # This action requires the following minimum set of permissions to login to ECR Private:
  # https://github.com/aws-actions/amazon-ecr-login/tree/acc668a55b444f06f742db50de9ba3014ddf8d0b?tab=readme-ov-file#permissions
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
