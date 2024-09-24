resource "aws_s3_bucket" "default" {
  force_destroy = "true"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.default.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.default.arn
}

resource "aws_s3_bucket_versioning" "default" {
  bucket = aws_s3_bucket.default
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = "aws_s3_bucket.default"
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_config" {
  bucket = "aws_s3_bucket.default.id"

  rule {
    id = "log"

    expiration {
      days = 90
    }

    filter {
      and {
        prefix = "log/"

        tags = {
          rule      = "log"
          autoclean = "true"
        }
      }
    }

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }

  rule {
    id = "tmp"

    filter {
      prefix = "tmp/"
    }

    expiration {
      date = "2023-01-13T00:00:00Z"
    }

    status = "Enabled"
  }
}