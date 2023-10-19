resource "aws_s3_bucket" "website_root" {
  bucket = var.domain
}

resource "aws_s3_bucket_acl" "website_root" {
  bucket = aws_s3_bucket.website_root.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "website_root" {
  bucket = aws_s3_bucket.website_root.id
  policy = data.aws_iam_policy_document.website_root.json
}

resource "aws_s3_bucket_public_access_block" "website_root" {
  bucket             = aws_s3_bucket.website_root.id
  block_public_acls  = true
  ignore_public_acls = true
}

resource "aws_s3_bucket_website_configuration" "website_root" {
  bucket = aws_s3_bucket.website_root.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket" "website_www" {
  bucket = "www.${var.domain}"
}

resource "aws_s3_bucket_acl" "website_www" {
  bucket = aws_s3_bucket.website_www.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "website_www" {
  bucket = aws_s3_bucket.website_www.id
  policy = data.aws_iam_policy_document.website_www.json
}

resource "aws_s3_bucket_public_access_block" "website_www" {
  bucket             = aws_s3_bucket.website_www.id
  block_public_acls  = true
  ignore_public_acls = true
}

resource "aws_s3_bucket_website_configuration" "website_www" {
  bucket = aws_s3_bucket.website_www.id
  redirect_all_requests_to {
    protocol  = "https"
    host_name = var.domain
  }
}
