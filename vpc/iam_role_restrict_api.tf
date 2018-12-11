resource "aws_iam_role" "bru_api_execution" {
  name = "bru_api_assume"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "bru_api_execution" {
    role       = "${aws_iam_role.bru_api_execution.name}"
    policy_arn = "${aws_iam_policy.bru_api_restriction.arn}"
}

output "aws_iam_role.bru_api_execution.id" {
  value = "${aws_iam_role.bru_api_execution.id}"
}

output "aws_iam_role.bru_api_execution.arn" {
  value = "${aws_iam_role.bru_api_execution.arn}"
}

output "aws_iam_role.bru_api_execution.create_date" {
  value = "${aws_iam_role.bru_api_execution.create_date}"
}

output "aws_iam_role.bru_api_execution.unique_id" {
  value = "${aws_iam_role.bru_api_execution.unique_id}"
}

output "aws_iam_role_policy_attachment.bru_api_execution.id" {
  value = "${aws_iam_role_policy_attachment.bru_api_execution.id}"
}

