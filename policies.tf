resource "aws_iam_role" "role" {
  name = "lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "api_gateway_invoke_role" {
  name = "api_gateway_invoke_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "api_gateway_invoke_policy" {
  name = "api_gateway_invoke_policy"
  role = "${aws_iam_role.api_gateway_invoke_role.id}"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "lambda:InvokeFunction",
        Effect = "Allow",
        Resource = "${aws_lambda_function.lambda_prices.arn}"
      }
    ]
  })
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_prices.arn}" #Considerar cambiar arn por function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_apigatewayv2_api.api_gw.execution_arn}/*/*/*"
}