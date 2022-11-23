# Lambda execution 

resource "aws_iam_role" "lambda_exec" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = "AllowLambdaExec"
      Principal = {
        Service = "lambda.amazonaws.com"
    } }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# S3 read

data "aws_iam_policy_document" "allow_s3_read" {
  statement {
    sid = "AllowS3Read"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.lambda_exec.arn]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.lambda_data_in.arn,
      "${aws_s3_bucket.lambda_data_in.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "allow_s3_read" {
  bucket = aws_s3_bucket.lambda_data_in.id
  policy = data.aws_iam_policy_document.allow_s3_read.json
}

# S3 write

data "aws_iam_policy_document" "allow_s3_write" {
  statement {
    sid = "AllowS3Write"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.lambda_exec.arn]
    }

    actions = [
      "s3:PutObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.lambda_data_out.arn,
      "${aws_s3_bucket.lambda_data_out.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "allow_s3_write" {
  bucket = aws_s3_bucket.lambda_data_out.id
  policy = data.aws_iam_policy_document.allow_s3_write.json
}


# S3 trigger

resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = aws_s3_bucket.lambda_data_in.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.process_image.arn
    events              = ["s3:ObjectCreated:*"]

  }
}

resource "aws_lambda_permission" "s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.process_image.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.lambda_data_in.arn
}
