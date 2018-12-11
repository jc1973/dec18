resource "aws_iam_policy" "bru_api_restriction" {
  name        = "bru_api_restriction"
  path        = "/"
  description = "Biometric Re-use API restriction"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "execute-api:Invoke"
            ],
            "Resource": "arn:aws:execute-api:*:*:*"
        }
    ]
}
EOF
}

#### OUTPUTS ####

output "aws_iam_policy.bru_api_restriction.id" {
  value = "${aws_iam_policy.bru_api_restriction.id}"
}

output "aws_iam_policy.bru_api_restriction.arn" {
  value = "${aws_iam_policy.bru_api_restriction.arn}"
}

