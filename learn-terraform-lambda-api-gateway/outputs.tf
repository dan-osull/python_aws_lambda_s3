# Output value definitions

output "lambda_source_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambda_code.id
}

output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.hello_world.function_name
}
