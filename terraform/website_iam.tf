data "aws_iam_policy_document" "website_root" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    resources = [
      "arn:aws:s3:::${var.domain}/*",
    ]
  }
}

data "aws_iam_policy_document" "website_www" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    resources = [
      "arn:aws:s3:::www.${var.domain}/*",
    ]
  }
}

resource "aws_iam_policy" "cloudfront_create_invalidation" {
  name        = "CloudFrontCreateInvalidation"
  description = "Used by CI pipelines to invalidate cache"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "VisualEditor0",
        Effect   = "Allow",
        Action   = "cloudfront:CreateInvalidation",
        Resource = "*",
      }
    ]
  })
}
