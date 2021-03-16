provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = "terraform-bucket-example"

  # prevent accidental deletion
  lifecycle {
    //    prevent_destroy = true
  }

  # enable versioning to see entire history of state files
  versioning {
    enabled = true
  }

  # enable encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# create dynamodb table to use for locking - https://bit.ly/3vtAOG8
resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-lock-example"
  # billing_mode controls how you are charged for read and write throughput and how you manage capacity
  billing_mode = "PAY_PER_REQUEST"
  # partition key
  hash_key = "LockID"

  # define string attribute
  attribute {
    name = "LockID"
    type = "S"
  }
}
