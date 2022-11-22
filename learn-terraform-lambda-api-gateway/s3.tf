# S3 for Lambda source code

resource "aws_s3_bucket" "lambda_code" {
  bucket = "lambda-code--${random_pet.random_suffix.id}"
}

resource "aws_s3_bucket_acl" "lambda_code_acl" {
  bucket = aws_s3_bucket.lambda_code.id
  acl    = "private"
}

# S3 for Lambda data input

resource "aws_s3_bucket" "lambda_data_in" {
  bucket = "lambda-data-in--${random_pet.random_suffix.id}"
}

resource "aws_s3_bucket_acl" "lambda_data_in" {
  bucket = aws_s3_bucket.lambda_data_in.id
  acl    = "private"
}
