data "archive_file" "lambda" {
  type = "zip"
  source_dir = "${var.lambda_code_dir}"
  output_path = "lambda.zip"
}

resource "aws_lambda_function" "hello_world_lambda_function" {
  filename = "${data.archive_file.lambda.output_path}"
  function_name = "lambda-${ var.project }${ var.environment }"
  role = "${aws_iam_role.lambda_role.arn}"
  handler = "index.handler"
  runtime = "nodejs4.3"
  source_code_hash = "${base64sha256(file("${data.archive_file.lambda.output_path}"))}"
  publish = true
}


resource "aws_iam_role" "lambda_role" {
  name = "iamrole-lambda-${ var.project }${ var.environment }"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.hello_world_lambda_function.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.hello_world_deployment.execution_arn}/*/*"
}


output "aws_iam_role.lambda_role.id" {
  value = "${aws_iam_role.lambda_role.id}"
}

output "aws_iam_role.lambda_role.arn" {
  value = "${aws_iam_role.lambda_role.arn}"
}

output "aws_iam_role.lambda_role.create_date" {
  value = "${aws_iam_role.lambda_role.create_date}"
}

output "aws_iam_role.lambda_role.unique_id" {
  value = "${aws_iam_role.lambda_role.unique_id}"
}

output "aws_lambda_function.hello_world_lambda_function.id" {
  value = "${aws_lambda_function.hello_world_lambda_function.id}"
}

output "aws_lambda_function.hello_world_lambda_function.arn" {
  value = "${aws_lambda_function.hello_world_lambda_function.arn}"
}

output "aws_lambda_function.hello_world_lambda_function.invoke_arn" {
  value = "${aws_lambda_function.hello_world_lambda_function.invoke_arn}"
}

output "aws_lambda_function.hello_world_lambda_function.last_modified" {
  value = "${aws_lambda_function.hello_world_lambda_function.last_modified}"
}

output "aws_lambda_function.hello_world_lambda_function.qualified_arn" {
  value = "${aws_lambda_function.hello_world_lambda_function.qualified_arn}"
}

output "aws_lambda_function.hello_world_lambda_function.version" {
  value = "${aws_lambda_function.hello_world_lambda_function.version}"
}
