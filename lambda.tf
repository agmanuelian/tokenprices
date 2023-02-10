resource "aws_lambda_function" "lambda_prices" {
  function_name = "lambda_prices"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  filename      = "function.zip"
  source_code_hash = "${base64sha256(filebase64("function.zip"))}"

  role = "${aws_iam_role.role.arn}"
}

