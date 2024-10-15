resource "aws_s3_bucket" "source" {
  force_destroy = "true"
  provider      = aws.west
  versioning {
    enabled = true
  }

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "destination" {
  force_destroy = "true"
  provider      = aws.east
  versioning {
    enabled = true
  }
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

