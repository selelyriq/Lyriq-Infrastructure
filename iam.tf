
###S3 Replication IAM

resource "aws_iam_role" "replication" {
  name = "your-replication-role-name"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

resource "aws_iam_policy" "replication" {
  name   = "tf-iam-policy-replication-12345"
  policy = data.aws_iam_policy_document.replication.json
}

data "aws_iam_policy_document" "replication" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning",
      "s3:GetBucketLifecycleConfiguration",
      "s3:PutBucketLifecycleConfiguration",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
    ]

    resources = [
        aws_s3_bucket.source.arn,
        "${aws_s3_bucket.source.arn}/*",
        aws_s3_bucket.destination.arn,
        "${aws_s3_bucket.destination.arn}/*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
    ]

    resources = ["${aws_s3_bucket.source.arn}/*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
    ]

    resources = ["${aws_s3_bucket.destination.arn}/*"]
  }
}

###Scaling IAM

resource "aws_iam_role" "scaling" {
  name = "tf-iam-role-scaling-12345"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "autoscaling.amazonaws.com"
        }
      }
    ]
  })
}

output "scaling_role_name" {
  value = aws_iam_role.scaling.name
}

output "scaling_role_arn" {
  value = aws_iam_role.scaling.arn
}

resource "aws_iam_role_policy_attachment" "scaling" {
  role       = aws_iam_role.scaling.name
  policy_arn = aws_iam_policy.scaling.arn
}

resource "aws_iam_policy" "scaling" {
  name   = "tf-iam-policy-scaling-12345"
  policy = data.aws_iam_policy_document.scaling.json
}

data "aws_iam_policy_document" "scaling" {
  statement {
    effect = "Allow"

    actions = [
      "autoscaling:CompleteLifecycleAction",
    ]

    resources = ["*"]
  }
}