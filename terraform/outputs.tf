# Output value definitions

output "s3_output_bucket_name" {
  description = "Name of S3 bucket used for data output"
  value       = aws_s3_bucket.lambda_data_out.id
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.process_image.function_name
}
