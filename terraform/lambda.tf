data "archive_file" "lambda_code_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/src.zip"
}

resource "aws_s3_object" "lambda_code_zip" {
  bucket = aws_s3_bucket.lambda_code.id

  key    = "src.zip"
  source = data.archive_file.lambda_code_zip.output_path

  etag = filemd5(data.archive_file.lambda_code_zip.output_path)
}

resource "aws_lambda_function" "process_image" {
  function_name = "ProcessImage"

  s3_bucket = aws_s3_bucket.lambda_code.id
  s3_key    = aws_s3_object.lambda_code_zip.key

  runtime = "python3.9"
  handler = "lambda.handler"

  source_code_hash = data.archive_file.lambda_code_zip.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}
