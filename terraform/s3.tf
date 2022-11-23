# S3 for Lambda source code

resource "aws_s3_bucket" "lambda_code" {
  bucket = "lambda-code--${random_pet.random_suffix.id}"
}

# S3 for Lambda data input

resource "aws_s3_bucket" "lambda_data_in" {
  bucket = "lambda-data-in--${random_pet.random_suffix.id}"
}

# S3 for Lambda data output

resource "aws_s3_bucket" "lambda_data_out" {
  bucket = "lambda-data-out--${random_pet.random_suffix.id}"
}
