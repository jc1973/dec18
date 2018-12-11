variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

variable "region" {
  type = "string"
  default = "eu-west-1"
}

variable "project" {
  type = "string"
  default = "hello_world"
}


variable "environment" {
  type = "string"
  default = "test"
}

variable "lambda_code_dir" {
  type = "string"
  default = "../nodejs/hello-world"
}
