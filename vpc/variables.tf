variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

variable "region" {
  type = "string"
  default = "eu-west-1"
}

variable "stream_code" {
  type = "string"
  default = "por"
}

variable "sub_project" {
  type = "string"
  default = "bru"
}

variable "int_ext" {
  type = "string"
  default = "i"
}

variable "environment" {
  type = "string"
  default = "test"
}

variable "service" {
  type = "string"
  default = "bru"
}

variable "lambda_retrieve_code_dir" {
  type = "string"
  default = "../retrieve"
}
