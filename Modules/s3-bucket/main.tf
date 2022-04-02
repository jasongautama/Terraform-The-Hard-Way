provider "aws" {
  shared_config_files      = ["/Users/jason.gautama/.aws/config"]
  shared_credentials_files = ["/Users/jason.gautama/.aws/credentials"]
  region                   = "ap-southeast-1"
  profile                  = "default"
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "terraform-state-apr-2022-1a4f"
}

# Enable versioning to see history of state files
resource "aws_s3_bucket_versioning" "terraform_state_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_bucket_sse_config" {
  bucket = aws_s3_bucket.terraform_state_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks-apr-2022-1a4f"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "bucket_name" {
  value       = "S3: ${aws_s3_bucket.terraform_state_bucket.arn}"
  description = "bucket arn created"
}
