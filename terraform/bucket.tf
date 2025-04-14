resource "aws_s3_bucket" "bucket" {
  bucket        = "tfstate-for-ec2-instance-jose-manuel"
  force_destroy = true

  tags = {
    Name = var.name
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  depends_on = [ aws_s3_bucket_public_access_block.bucket_public_access_block ]

  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = [
          "s3:PutBucketPolicy",
          "s3:ListBucket"
        ]
        Resource  = [ 
          aws_s3_bucket.bucket.arn
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "bucket_policy_objects" {
  depends_on = [ aws_s3_bucket_public_access_block.bucket_public_access_block ]

  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource  = [ 
          "${aws_s3_bucket.bucket.arn}/*"
        ]
      }
    ]
  })
}