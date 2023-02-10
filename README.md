# AWS Infrastructure Deployment with Terraform - Token price API
This project deploys AWS infrastructure using Terraform. The main purpose of this infrastructure is to retrieve the price of a cryptocurrency token using the Coingecko API. The infrastructure includes an API Gateway (REST API) and a Lambda function.

## Requirements
⋅ Terraform installed in your environment.

⋅ AWS account with sufficient permissions to create and manage AWS resources.

## How to deploy the infrastructure
1. Clone the repository to your local machine.
2. Navigate to the root of the project in the terminal.
3. Set up your own AWS credentials in the `main.tf` file.
4. Initialize Terraform by running `terraform init`.
5. Create an execution plan by running `terraform plan`.
6. Apply the plan by running `terraform apply`.


### main.tf
This file contains the Terraform code that deploys the AWS infrastructure. It creates an API Gateway (REST API) and a Lambda function. This includes deploying the API gateway, linking it to the Lambda function so it triggers it when it's invoked, and uploads all the necessary files to the Lambda function.

### lambda_function.py
This file contains the Python code for the Lambda function that retrieves the price of a cryptocurrency token.

### function.zip
This file contains the Terraform variables used in the main.tf file.

## Deployment Details
The Terraform code creates the following AWS resources:

⋅ API Gateway (REST API)
⋅ Lambda function

The API Gateway is connected to the Lambda function. When a GET request is made to the API with a `"symbol"` querystring parameter, the Lambda function retrieves the price of the corresponding cryptocurrency token.

### API syntax

`https://{base-url}/price?symbol=btc`

### Note
Don't forget to destroy the infrastructure when you are done using it, by running `terraform destroy`.
