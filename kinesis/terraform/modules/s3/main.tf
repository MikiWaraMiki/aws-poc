resource "aws_s3_bucket" "private" {
  bucket = var.bucket_name
  acl    = "private"
  versioning {
    enabled = true
  }
  # Life Cycle is Static
  lifecycle_rule {
    enabled = true
    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }

    transition {
      days          = 200
      storage_class = "GLACIER"
    }
  }
}
