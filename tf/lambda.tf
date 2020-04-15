resource "aws_lambda_function" "lambda_function" {
  function_name    = "${var.lambda_name}_${var.env}"
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  filename         = var.lambda_filename
  role             = aws_iam_role.lambda_exec_role.arn
  source_code_hash = filebase64sha256(var.lambda_filename)

  tags = var.tags
}

resource "aws_iam_role" "lambda_exec_role" {
  name        = "${var.lambda_name}_iam_role_${var.env}"
  path        = "/"
  description = "Allows Lambda Function to call AWS services on your behalf."

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )

  tags = var.tags
}
