data "aws_iam_policy_document" "in-line_policy" {
  statement {
    sid = "1"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }
}


data "aws_iam_policy_document" "instance_inline_policy" {
  statement {
    sid = "1"

    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeNetworkInterfaces",

    ]

    resources = [
      "*",
    ]
  }
}


data "aws_iam_policy_document" "simplydantech" {}

data "aws_iam_policy_document" "ssm_remote_access" {
  statement {
    sid = "StartSession"
    actions = [
      "ssm:StartSession",
    ]
    resources = ["*"]
  }

  statement {
    sid = "SendCommand"
    actions = [
      "ssm:SendCommand",
    ]
    resources = ["*"]
  }

  statement {
    sid = "TerminateSession"
    actions = [
      "ssm:TerminateSession",
    ]
    resources = ["*"]
  }
}
