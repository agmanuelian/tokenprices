provider "aws" {
  region = "us-east-1"
  access_key="TO-DO-AccessKey"
  secret_key="TO-DO-SecretKey"
}

resource "aws_api_gateway_rest_api" "api_gw" {
  name = "token_prices_api"
}

resource "aws_api_gateway_resource" "price" {
  rest_api_id = "${aws_api_gateway_rest_api.api_gw.id}"
  parent_id   = "${aws_api_gateway_rest_api.api_gw.root_resource_id}"
  path_part   = "price"
}

resource "aws_lambda_function" "lambda_prices" {
  function_name = "lambda_prices"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  filename      = "function.zip"
  source_code_hash = "${base64sha256(filebase64("function.zip"))}"

  role = "${aws_iam_role.role.arn}"
}

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

resource "aws_api_gateway_request_validator" "validator" {
  rest_api_id = "${aws_api_gateway_rest_api.api_gw.id}"
  name        = "validator"
  validate_request_body = false
  validate_request_parameters = true
}

resource "aws_api_gateway_method" "get_price" {
  rest_api_id   = "${aws_api_gateway_rest_api.api_gw.id}"
  resource_id   = "${aws_api_gateway_resource.price.id}"
  http_method   = "GET"
  authorization = "NONE"

  request_validator_id = "${aws_api_gateway_request_validator.validator.id}"

  request_parameters = {
    "method.request.querystring.symbol" = true
  }

}

resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.api_gw.id}"
  resource_id = "${aws_api_gateway_resource.price.id}"
  http_method = "${aws_api_gateway_method.get_price.http_method}"
  integration_http_method = "GET"
  type        = "AWS"

  request_templates = {
    "application/json" = <<EOF
  {
    "symbol": "$input.params('symbol')"
  }
  EOF
  }

  uri         = aws_lambda_function.lambda_prices.invoke_arn
}

resource "aws_api_gateway_deployment" "apideploy" {
   depends_on = [
     aws_api_gateway_integration.api_integration
   ]

   rest_api_id = aws_api_gateway_rest_api.api_gw.id
   stage_name  = "test"
}

resource "aws_lambda_permission" "lambda_allow" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.lambda_prices.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.api_gw.execution_arn}/*/*"
}


output "base_url" {
  value = aws_api_gateway_deployment.apideploy.invoke_url
}