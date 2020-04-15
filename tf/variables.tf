variable "aws_region" {
  description = "AWS Regsion"
  type = string
}

variable "env" {
  description = "Environment"
  type = string
}

variable "lambda_name" {
  description = "Lambda function name"
  type = string
}

variable "lambda_handler" {
  description = "Lambda function handler"
  type = string
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  type = string
}

variable "lambda_filename" {
  description = "Lambda filename"
  type = string
}

variable "tags" {
  description = "Tagging resources"
}