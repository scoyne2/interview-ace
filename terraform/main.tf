provider "aws" {
  region = "us-west-2"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

# module "apigateway" {
#   source = "./modules/apigateway"
# }

# module "lambda" {
#   source = "./modules/lambda"
# }

# module "rds" {
#   source = "./modules/rds"
# }