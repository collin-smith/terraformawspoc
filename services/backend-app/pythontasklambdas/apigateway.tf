# API Gateway REST API
resource "aws_api_gateway_rest_api" "poc_api" {
  name        = "POC Tasks API"
  description = "API Gateway for POC Tasks API"
}

# ENDPOINT gettasks(GET)
# API Gateway Resource (Endpoint)
resource "aws_api_gateway_resource" "tasks" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  parent_id   = aws_api_gateway_rest_api.poc_api.root_resource_id
  path_part   = "tasks" 
}

# API Gateway Method
resource "aws_api_gateway_method" "gettasks_method" {
  rest_api_id   = aws_api_gateway_rest_api.poc_api.id
  resource_id   = aws_api_gateway_resource.tasks.id #
  http_method   = "GET" #
  authorization = "NONE"
}
# API Gateway Integration
resource "aws_api_gateway_integration" "gettasks_integration" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  resource_id = aws_api_gateway_resource.tasks.id #
  http_method = aws_api_gateway_method.gettasks_method.http_method #
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri = aws_lambda_function.lambda_gettasks.invoke_arn
}
# Lambda permission
resource "aws_lambda_permission" "lambda_permissionlambdagettasks" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_gettasks.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.poc_api.execution_arn}/*/*"
}


# ENDPOINT gettask(GET)
# API Gateway Resource (Endpoint)
resource "aws_api_gateway_resource" "task" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  parent_id   = aws_api_gateway_resource.tasks.id
  path_part   = "{id}"
}

# API Gateway Method
resource "aws_api_gateway_method" "task_method" {
  rest_api_id   = aws_api_gateway_rest_api.poc_api.id
  resource_id   = aws_api_gateway_resource.task.id
  http_method   = "GET"
  authorization = "NONE"
}

# API Gateway Integration
resource "aws_api_gateway_integration" "gettask_integration" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  resource_id = aws_api_gateway_resource.task.id
  http_method = aws_api_gateway_method.gettasks_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri = aws_lambda_function.lambda_gettask.invoke_arn
}
# Lambda permission
resource "aws_lambda_permission" "lambda_permissionlambdagettask" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_gettask.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.poc_api.execution_arn}/*/*"
}
# insert Lambda End

# API Gateway Method
resource "aws_api_gateway_method" "createtask_method" {
  rest_api_id   = aws_api_gateway_rest_api.poc_api.id
  resource_id   = aws_api_gateway_resource.tasks.id #
  http_method   = "POST" #
  authorization = "NONE"
}
# API Gateway Integration
resource "aws_api_gateway_integration" "createtask_integration" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  resource_id = aws_api_gateway_resource.tasks.id #
  http_method = aws_api_gateway_method.createtask_method.http_method #
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri = aws_lambda_function.lambda_createtask.invoke_arn
}
# Lambda permission
resource "aws_lambda_permission" "lambda_permissionlambdacreatetasks" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_createtask.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.poc_api.execution_arn}/*/*"
}

# API Gateway Method
resource "aws_api_gateway_method" "updatetask_method" {
  rest_api_id   = aws_api_gateway_rest_api.poc_api.id
  resource_id   = aws_api_gateway_resource.tasks.id #
  http_method   = "PUT" #
  authorization = "NONE"
}

#CORS
resource "aws_api_gateway_method" "cors_options" {
  rest_api_id   = aws_api_gateway_rest_api.poc_api.id
  resource_id   = aws_api_gateway_resource.tasks.id #
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cors_integration" {
  rest_api_id   = aws_api_gateway_rest_api.poc_api.id
  resource_id   = aws_api_gateway_resource.tasks.id #
  http_method = aws_api_gateway_method.cors_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "cors_integration_response" {
  rest_api_id   = aws_api_gateway_rest_api.poc_api.id
  resource_id   = aws_api_gateway_resource.tasks.id #
  http_method = aws_api_gateway_method.cors_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  #Add the cors after the non-get functions are created (POST, PUT, DELETE)
  depends_on = [
    aws_api_gateway_method.createtask_method,
    aws_api_gateway_integration.createtask_integration,
    aws_api_gateway_method.updatetask_method,
    aws_api_gateway_integration.updatetask_integration,
    aws_api_gateway_method.deletetask_method,
    aws_api_gateway_integration.deletetask_integration,
  ]

}

resource "aws_api_gateway_method_response" "cors_method_response" {
  rest_api_id   = aws_api_gateway_rest_api.poc_api.id
  resource_id   = aws_api_gateway_resource.tasks.id #
  http_method = aws_api_gateway_method.cors_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}




# API Gateway Integration
resource "aws_api_gateway_integration" "updatetask_integration" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  resource_id = aws_api_gateway_resource.tasks.id #
  http_method = aws_api_gateway_method.updatetask_method.http_method #
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri = aws_lambda_function.lambda_updatetask.invoke_arn
}
# Lambda permission
resource "aws_lambda_permission" "lambda_permissionlambdaupdatetask" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_updatetask.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.poc_api.execution_arn}/*/*"
}

# API Gateway Method  
resource "aws_api_gateway_method" "deletetask_method" {
  rest_api_id   = aws_api_gateway_rest_api.poc_api.id
  resource_id   = aws_api_gateway_resource.tasks.id #
  http_method   = "DELETE" 
  authorization = "NONE"
}

# API Gateway Integration 
resource "aws_api_gateway_integration" "deletetask_integration" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  resource_id = aws_api_gateway_resource.tasks.id #
  http_method = aws_api_gateway_method.deletetask_method.http_method #
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri = aws_lambda_function.lambda_deletetask.invoke_arn
}

# Lambda permission
resource "aws_lambda_permission" "lambda_permissionlambdadeletetask" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_deletetask.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.poc_api.execution_arn}/*/*"
}

# Deploy API Gateway Deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.gettasks_integration,
    aws_api_gateway_integration.gettask_integration,
    aws_api_gateway_integration.createtask_integration,
    aws_api_gateway_integration.updatetask_integration,
    aws_api_gateway_integration.deletetask_integration,
  ]
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
}

resource "aws_api_gateway_stage" "api_deployment" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.poc_api.id
  stage_name    = "prod"
}
