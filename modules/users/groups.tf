module "robot_groups" {
  source = "./group"
  group_name = var.robot_group_name
  account_id_mapping = var.account_id_mapping
}

module "write_groups" {
  source = "./group"
  group_name = var.write_group_name
  account_id_mapping = var.account_id_mapping
}

module "read_groups" {
  source = "./group"
  group_name = var.read_group_name
  account_id_mapping = var.account_id_mapping
}


resource "aws_iam_group" "human_account" {
  name  = var.human_group_name
}

data "aws_iam_policy_document" "human_account" {

  statement {
    sid = "AllowAllUsersToListAccounts"

    actions = [
      "iam:ListAccountAliases",
      "iam:ListUsers",
      "iam:GetAccountSummary"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid = "AllowIndividualUserToSeeAndManageOnlyTheirOwnAccountInformation"

    actions = [
      "iam:ChangePassword",
      "iam:CreateAccessKey",
      "iam:CreateLoginProfile",
      "iam:DeleteAccessKey",
      "iam:DeleteLoginProfile",
      "iam:GetAccountPasswordPolicy",
      "iam:GetLoginProfile",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKey",
      "iam:UpdateLoginProfile",
      "iam:ListSigningCertificates",
      "iam:DeleteSigningCertificate",
      "iam:UpdateSigningCertificate",
      "iam:UploadSigningCertificate",
      "iam:ListSSHPublicKeys",
      "iam:GetSSHPublicKey",
      "iam:DeleteSSHPublicKey",
      "iam:UpdateSSHPublicKey",
      "iam:UploadSSHPublicKey"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}"
    ]
  }

  statement {
    sid = "AllowIndividualUserToListOnlyTheirOwnMFA"

    actions = [
      "iam:ListVirtualMFADevices",
      "iam:ListMFADevices"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}"
    ]
  }

  statement {
    sid = "AllowIndividualUserToManageTheirOwnMFA"

    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:RequestSmsMfaRegistration",
      "iam:FinalizeSmsMfaRegistration",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/$${aws:username}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}"
    ]
  }

  statement {
    sid = "AllowIndividualUserToDeactivateOnlyTheirOwnMFAOnlyWhenUsingMFA"

    actions = [
      "iam:DeactivateMFADevice"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/$${aws:username}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}"
    ]

    condition {
      test = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values = ["true"]
    }
  }

  statement {
    sid = "BlockAnyAccessOtherThanAboveUnlessSignedInWithMFA"

    effect = "Deny"

    not_actions = [
      "iam:*"
    ]

    resources = [
      "*"
    ]

    condition {
      test = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values = ["false"]
    }
  }

}

resource "aws_iam_policy" "human_account" {
  name        = "IAMPermission"
  description = "policy for basic iam permission"
  policy      = data.aws_iam_policy_document.human_account.json
}

resource "aws_iam_group_policy_attachment" "main" {
  group      = aws_iam_group.human_account.name
  policy_arn = aws_iam_policy.human_account.arn
}