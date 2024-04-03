# resource "aws_api_gateway_rest_api" "lambda_api" {
#   name        = "lambda_ses_api"
#   description = "This is my API for demonstration purposes"

#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
# }

# resource "aws_api_gateway_resource" "api_resource" {
#   rest_api_id = aws_api_gateway_rest_api.lambda_api.id
#   parent_id   = aws_api_gateway_rest_api.lambda_api.root_resource_id
#   path_part   = "lam_api"
# }

# resource "aws_api_gateway_method" "api_gateway" {
#   rest_api_id   = aws_api_gateway_rest_api.lambda_api.id
#   resource_id   = aws_api_gateway_resource.api_resource.id
#   http_method   = "POST"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "options_method" {
#   rest_api_id = aws_api_gateway_rest_api.lambda_api.id
#   resource_id = aws_api_gateway_resource.api_resource.id
#   http_method = "OPTIONS"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "api_gateway_integration" {
#   rest_api_id = aws_api_gateway_rest_api.lambda_api.id
#   resource_id = aws_api_gateway_resource.api_resource.id
#   http_method = aws_api_gateway_method.api_gateway.http_method
#   integration_http_method = "POST"
#   type = "AWS_PROXY"
#   uri = aws_lambda_function.lambda_api.invoke_arn
# }

# # Mock Integration for OPTIONS method (doesn't call Lambda)
# resource "aws_api_gateway_integration" "api_integration" {
#   rest_api_id = aws_api_gateway_rest_api.lambda_api.id
#   resource_id = aws_api_gateway_resource.api_resource.id
#   http_method = aws_api_gateway_method.api_gateway.http_method
#   type        = "MOCK"
#   request_templates = {
#     "application/json" = "{ \"statusCode\": 200 }"
#   }
# }

# # Integration Response for OPTIONS method with CORS headers
# resource "aws_api_gateway_integration_response" "options_response" {
#   rest_api_id = aws_api_gateway_rest_api.lambda_api.id
#   resource_id = aws_api_gateway_resource.api_resource.id
#   http_method = aws_api_gateway_method.api_gateway.http_method
#   status_code = "200"
#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin" = "'*'"  # Replace with your allowed origins
#     "method.response.header.Access-Control-Allow-Methods" = "'GET'"  # Replace with allowed methods (adjust based on your API)
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key'"  # Replace with allowed headers
#   }
# }

# # Deployment Stage for Production
# resource "aws_api_gateway_deployment" "production" {
#   rest_api_id = aws_api_gateway_rest_api.lambda_api.id
#   stage_name  = "production"
#   description = "Production deployment for lambda_ses_api"

#   # Link the deployment to a specific API Gateway stage
#   # variables = {
#   #   "basePath" = "/"
#   # }
# }

# /////////////////////////////////////////////////////////////



# Create the API Gateway
resource "aws_api_gateway_rest_api" "lambda_api" {
  name        = "lambda_ses_api"
  description = "This is my API for demonstration purposes"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Define the API resource path
resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  parent_id   = aws_api_gateway_rest_api.lambda_api.root_resource_id
  path_part   = "lam_api"
}

# Define the GET method for your API
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# Define the OPTIONS method for CORS preflight requests
resource "aws_api_gateway_method" "options_method" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = "OPTIONS"
  authorization = "NONE"
}

# Integration for GET requests to your Lambda function
resource "aws_api_gateway_integration" "api_gateway_integration" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.lambda_api.invoke_arn
}

# Mock Integration for OPTIONS method (doesn't call Lambda)
resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
}

# Define the method response for OPTIONS requests
resource "aws_api_gateway_method_response" "options_method_response" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"
  # Optional: Define response parameters and response models if needed
}

# # Integration Response for OPTIONS method with CORS headers
# resource "aws_api_gateway_integration_response" "options_response" {
#   rest_api_id = aws_api_gateway_rest_api.lambda_api.id
#   resource_id = aws_api_gateway_resource.api_resource.id
#   http_method = aws_api_gateway_method.options_method.http_method
#   status_code = "200"
#   method_response_id = aws_api_gateway_method_response.options_method_response.id
#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin" = "'*'"  # Replace with your allowed origins
#     "method.response.header.Access-Control-Allow-Methods" = "'GET'"  # Replace with allowed methods (adjust based on your API)
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key'"  # Replace with allowed headers
#   }
# }

# Deployment Stage for Production
resource "aws_api_gateway_deployment" "production" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  stage_name  = "production"
  description = "Production deployment for lambda_ses_api"

  # Link the deployment to a specific API Gateway stage
  # variables = {
  #   "basePath" = "/"
  # }

  depends_on = [
    aws_api_gateway_integration.api_gateway_integration,
    aws_api_gateway_integration.options_integration  # Ensure CORS integration is deployed
  ]
}