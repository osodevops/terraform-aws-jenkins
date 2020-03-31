data "aws_iam_policy_document" "local_admin" {
  statement {
    resources = ["*"]

    not_actions = [
      "config:*",
      "cloudtrail:*",
      "organizations:*",
      "iam:CreateAccountAlias",
      "iam:DeleteAccountAlias",
      "iam:DeleteAccountPasswordPolicy",
      "iam:*SAMLProvider",
      "cloudformation:*StackSet*",
    ]
  }

  statement {
    actions = [
      "cloudformation:DeleteStack",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:SetStackPolicy",
      "cloudformation:UpdateStack",
      "cloudformation:CancelUpdateStack",
      "cloudformation:ContinueUpdateRollback",
      "cloudformation:CreateStack",
      "cloudformation:CreateChangeSet",
    ]

    resources = [
      "arn:aws:cloudformation:*:*:stack/StackSet-*/*"
    ]

    effect = "Deny"
    sid    = "DenyCFStacks"
  }

  statement {
    actions = [
      "sts:AssumeRole*",
    ]

    resources = [
      "arn:aws:iam::*:role/AWSCloudFormationStackSet*"
    ]

    effect = "Deny"
    sid    = "DenyAssumeRoles"
  }
}
