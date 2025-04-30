variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {
  default = "us-east-1"
}
variable "key_name" {
  description = "Name of the AWS EC2 Key Pair"
}
