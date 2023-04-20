resource "aws_s3_bucket" "config_bucket" {
  bucket = var.s3_bucket_name

  tags = var.tags
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.config_bucket.id
  key    = var.s3_bucket_key  
  source = var.s3_object_upload
  etag   = filemd5(var.s3_object_upload)
}

resource "aws_s3_bucket_public_access_block" "config_s3_block_public_access" {
  bucket = aws_s3_bucket.config_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "config_bucket_acl" {
  bucket = aws_s3_bucket.config_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_config_bucket" {
  bucket = aws_s3_bucket.config_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_asg" {
  bucket = aws_s3_bucket.config_bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_asg_policy.json
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.config_bucket.id

  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
  }
}

data "aws_iam_policy_document" "allow_access_from_asg_policy" {
  statement {
    sid = "S3BucketPolicy"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = [var.aws_account_id]
    }

    actions = [
        "s3:GetObjectAcl",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:GetObjectVersion"
    ]

    resources = [
      aws_s3_bucket.config_bucket.arn,
      "${aws_s3_bucket.config_bucket.arn}/*",
    ]
  }
}
