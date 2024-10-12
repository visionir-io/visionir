data "aws_caller_identity" "current" {}

# S3 Bucket for Terraform state
resource "aws_s3_bucket" "tf_state" {
  bucket = "visionir-tf-state"
  tags = {
    Name = "TerraformStateBucket"
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.tf_state.bucket
  versioning_configuration {
    status = "Enabled"
  }
  depends_on = [aws_s3_bucket.tf_state]
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "TerraformLocksTable"
  }
}

# IAM Policy for accessing S3 and DynamoDB
data "aws_iam_policy_document" "terraform_state_policy" {
  statement {
    actions = [
      "s3:List*",
      "s3:Get*",
      "s3:Put*",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.tf_state.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.tf_state.bucket}/*"
    ]
  }

  statement {
    actions = [
      "dynamodb:*",
      "dynamodb:DescribeTable"
    ]

    resources = [
      "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.terraform_locks.name}"
    ]
  }
  statement {
    actions = [
      "iam:Get*",
      "iam:List*",
      "iam:PassRole"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${aws_iam_user.terraform_user.name}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.aws_tf_state_policy_name}",
    ]
  }
}

resource "aws_iam_policy" "terraform_state_policy" {
  name        = var.aws_tf_state_policy_name
  description = "Policy for accessing Terraform state in S3 and locking in DynamoDB"
  policy      = data.aws_iam_policy_document.terraform_state_policy.json
  depends_on  = [data.aws_iam_policy_document.terraform_state_policy]
}

# IAM User for Terraform
resource "aws_iam_user" "terraform_user" {
  name = "TerraformUser"
  tags = {
    Name = "TerraformUser"
  }
}

resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.terraform_user.name
  policy_arn = aws_iam_policy.terraform_state_policy.arn
  depends_on = [aws_iam_user.terraform_user, aws_iam_policy.terraform_state_policy]
}

resource "aws_iam_access_key" "terraform_access_key" {
  user = aws_iam_user.terraform_user.name
}
