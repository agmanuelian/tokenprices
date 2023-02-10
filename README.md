#AWS Infrastructure Deployment with Terraform and Lambda
This project deploys the AWS infrastructure using Terraform. The main purpose of this infrastructure is to retrieve the price of a cryptocurrency token using the Coingecko API. The infrastructure includes an API Gateway (REST API) and a Lambda function.

Requirements
⋅⋅*Terraform installed in your environment.
⋅⋅*AWS account with sufficient permissions to create and manage AWS resources.

How to deploy the infrastructure
Clone the repository to your local machine.
Navigate to the root of the project in the terminal.
Initialize Terraform by running terraform init.
Create an execution plan by running terraform plan.
Apply the plan by running terraform apply.


main.tf
This file contains the Terraform code that deploys the AWS infrastructure. It creates an API Gateway (REST API) and a Lambda function.

lambda_function.py
This file contains the Python code for the Lambda function that retrieves the price of a cryptocurrency token.

variables.tf
This file contains the Terraform variables used in the main.tf file.

Deployment Details
The Terraform code creates the following AWS resources:

API Gateway (REST API)
Lambda function
The API Gateway is connected to the Lambda function. When a GET request is made to the API with a "symbol" querystring parameter, the Lambda function retrieves the price of the corresponding cryptocurrency token.

Note
Don't forget to destroy the infrastructure when you are done using it, by running terraform destroy.
