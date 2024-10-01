data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_s3_bucket" "source" {
  force_destroy = "true"
  provider      = aws.west

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "destination" {
  force_destroy = "true"
  provider      = aws.east
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.source.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.source.arn
}

resource "aws_s3_bucket_versioning" "source" {
  provider = aws.west
  bucket   = aws_s3_bucket.source.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "source" {
  provider = aws.west
  bucket   = aws_s3_bucket.source.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "destination" {
  provider = aws.east
  bucket   = aws_s3_bucket.destination.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.source.id
  depends_on = [aws_s3_bucket.source]
  acl    = "public-read"
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_config" {
  bucket = aws_s3_bucket.source.id

  rule {
    id = "log"

    expiration {
      days = 120
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
      days          = 90
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

resource "aws_s3_bucket_replication_configuration" "replication" {
  provider = aws.east
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.source]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.source.id

  rule {
    id = "foobar"

    filter {
      prefix = "foo"
    }

    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.destination.arn
      storage_class = "STANDARD"
    }
  }
}