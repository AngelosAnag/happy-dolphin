# s3 bucket with test file for pulling from EC2 instances

resource "aws_s3_bucket" "test_bucket" {
  bucket_prefix = "gateway-endpoint-demo-"

  tags = {
    Name        = "Bucket"
    Environment = "playground"
  }
}

resource "aws_s3_object" "test_file" {
  bucket  = aws_s3_bucket.test_bucket.id
  key     = "testfile.txt"
  content = <<EOT
This is a test file for S3 Gateway Endpoint demo.
EOT

  tags = {
    Name        = "TestFile"
    Environment = "playground"
  }
}

