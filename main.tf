provider "aws" {
  region = "us-east-1"
  access_key="TO-DO-AccessKey"
  secret_key="TO-DO-SecretKey"
}
  
output "URL" {
  value = "${aws_apigatewayv2_stage.lambda.invoke_url}/price?symbol=btc"
}
