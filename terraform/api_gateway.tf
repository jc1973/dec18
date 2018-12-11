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



########################################
## ADD PROXY TO HANDLE EMPTY ENDPOINT ##
########################################


resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.hello_world.id}"
  resource_id   = "${aws_api_gateway_rest_api.hello_world.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.hello_world.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.hello_world_lambda_function.invoke_arn}"
}




resource "aws_iam_role" "iam_for_api_gateway" {
  name = "iamrole-api-gateway-${ var.project }${ var.environment }"
  path = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam_policy_api_gateway" {
  role = "${aws_iam_role.iam_for_api_gateway.id}"
  name = "iamrole-api-gateway-${ var.project }${ var.environment }"
  policy = <<EOF
{

    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

#"aws_iam_policy" "hello_world_api_restriction"
resource "aws_iam_role_policy_attachment" "hello_world_api_restriction" {
    role       = "${aws_iam_role.iam_for_api_gateway.name}"
    policy_arn = "${aws_iam_policy.hello_world_api_restriction.arn}"
}



#### DEPLOY THE API'S #####

resource "aws_api_gateway_deployment" "hello_world_deployment" {
  depends_on = ["aws_api_gateway_integration.hello_world_lambda_integration", 
                "aws_api_gateway_integration.lambda_root"]
  rest_api_id = "${aws_api_gateway_rest_api.hello_world.id}"
  stage_name  = "${var.environment}"
}


######## OUTPUTS ###########
# 
# 
# output "aws_api_gateway_deployment.hello_world_api_deployment.id" {
#   value = "${aws_api_gateway_deployment.hello_world_api_deployment.id}"
# }
# 
# output "aws_api_gateway_deployment.hello_world_api_deployment.created_date" {
#   value = "${aws_api_gateway_deployment.hello_world_api_deployment.created_date}"
# }
# 
# output "aws_api_gateway_deployment.hello_world_api_deployment.execution_arn" {
#   value = "${aws_api_gateway_deployment.hello_world_api_deployment.execution_arn}"
# }
# 
# output "aws_api_gateway_deployment.hello_world_api_deployment.invoke_url" {
#   value = "${aws_api_gateway_deployment.hello_world_api_deployment.invoke_url}"
# }
# 
# output "aws_api_gateway_integration.hello_world_recieve_lambda_integration.id" {
#   value = "${aws_api_gateway_integration.hello_world_recieve_lambda_integration.id}"
# }
# 
# output "aws_api_gateway_integration.hello_world_recieve_lambda_integration.cache_namespace" {
#   value = "${aws_api_gateway_integration.hello_world_recieve_lambda_integration.cache_namespace}"
# }
# 
# output "aws_api_gateway_integration.hello_world_recieve_lambda_integration.passthrough_behavior" {
#   value = "${aws_api_gateway_integration.hello_world_recieve_lambda_integration.passthrough_behavior}"
# }
# 
# output "aws_api_gateway_integration_response.hello_world_api_integration_response.id" {
#   value = "${aws_api_gateway_integration_response.hello_world_api_integration_response.id}"
# }
# 
# output "aws_api_gateway_method.hello_world_api_method.id" {
#   value = "${aws_api_gateway_method.hello_world_api_method.id}"
# }
# 
# output "aws_api_gateway_method_response.200.id" {
#   value = "${aws_api_gateway_method_response.200.id}"
# }
# 
# output "aws_api_gateway_resource.hello_world_api_resource.id" {
#   value = "${aws_api_gateway_resource.hello_world_api_resource.id}"
# }
# 
# output "aws_api_gateway_resource.hello_world_api_resource.path" {
#   value = "${aws_api_gateway_resource.hello_world_api_resource.path}"
# }
# 
# output "aws_api_gateway_rest_api.hello_world_api.id" {
#   value = "${aws_api_gateway_rest_api.hello_world_api.id}"
# }
# 
# output "aws_api_gateway_rest_api.hello_world_api.created_date" {
#   value = "${aws_api_gateway_rest_api.hello_world_api.created_date}"
# }
# 
# output "aws_api_gateway_rest_api.hello_world_api.root_resource_id" {
#   value = "${aws_api_gateway_rest_api.hello_world_api.root_resource_id}"
# }
# 
# output "aws_iam_role.iam_for_api_gateway.id" {
#   value = "${aws_iam_role.iam_for_api_gateway.id}"
# }
# 
# output "aws_iam_role.iam_for_api_gateway.arn" {
#   value = "${aws_iam_role.iam_for_api_gateway.arn}"
# }
# 
# output "aws_iam_role.iam_for_api_gateway.create_date" {
#   value = "${aws_iam_role.iam_for_api_gateway.create_date}"
# }
# 
# output "aws_iam_role.iam_for_api_gateway.unique_id" {
#   value = "${aws_iam_role.iam_for_api_gateway.unique_id}"
# }
# 
# output "aws_iam_role_policy.iam_policy_api_gateway.id" {
#   value = "${aws_iam_role_policy.iam_policy_api_gateway.id}"
# }
# 

output "root_url" {
  value = "${aws_api_gateway_deployment.hello_world_deployment.invoke_url}"
}

