  data "aws_iam_policy_document" "policy" {
  provider = aws.log
  statement {
    sid    = "AWSLogDeliveryWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::news3logginganfw/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = ["099780746944"]
    }

    # condition {
    #   test     = "ArnLike"
    #   variable = "aws:SourceArn"
    #   values   = ["arn:aws:logs:*:289094324109:*"]
    # }

  }
  statement {
    sid    = "AWSLogDeliveryAclCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::news3logginganfw"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = ["099780746944"]
    }
    # condition {
    #   test     = "ArnLike"
    #   variable = "aws:SourceArn"
    #   values   = ["arn:aws:logs:*:289094324109:*"]
    # }
  }
}

output "json" {
  value = data.aws_iam_policy_document.policy.json
}
