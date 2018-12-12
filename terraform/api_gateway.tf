# Define API root
resource "aws_api_gateway_rest_api" "hello_world" {
  name = "HELLO_WORLD_API_${var.environment}"
  description = "Hello World Serverless"
}

#########################
### ENDPOINT RESOURCE ###
#########################

# resource to activate proxy behaviout on the endpoint
resource "aws_api_gateway_resource" "hello_world_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.hello_world.id}"
  parent_id   = "${aws_api_gateway_rest_api.hello_world.root_resource_id}"
  path_part   = "{proxy+}"
}

#  a method to handle any method on the endpoint
resource "aws_api_gateway_method" "hello_world_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.hello_world.id}"
  resource_id   = "${aws_api_gateway_resource.hello_world_resource.id}"
  http_method   = "ANY"
  authorization = "NONE"
}


# an integration to call the lambda function on the endpoint
resource "aws_api_gateway_integration" "hello_world_lambda_integration" {
  rest_api_id          = "${aws_api_gateway_rest_api.hello_world.id}"
  resource_id          = "${aws_api_gateway_method.hello_world_method.resource_id}"
  http_method          = "${aws_api_gateway_method.hello_world_method.http_method}"
  uri                  = "${aws_lambda_function.hello_world_lambda_function.invoke_arn}"
  type                 = "AWS_PROXY"
  integration_http_method     = "POST"
}


############################
## END ENDPOINT RESOURCES ##
############################

