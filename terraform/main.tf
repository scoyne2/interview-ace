provider "aws" {
  region = "us-west-2"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "lambda" {
  source = "./modules/lambda"
  connections-table-name = module.dynamodb.connections-table-name
  connections-history-table-name = module.dynamodb.connections-history-table-name
}

module "apigateway" {
  source = "./modules/apigateway"
  websocket-lambda-arn = module.lambda.websocket-lambda-arn
}

# module "rds" {
#   source = "./modules/rds"
# }