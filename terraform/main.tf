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
  depends_on = [module.dynamodb]
}

module "route53" {
  source = "./modules/route53"
}

module "apigateway" {
  source = "./modules/apigateway"
  websocket-lambda-arn = module.lambda.websocket-lambda-arn
  websocket-function-name = module.lambda.websocket-function-name
  aws-acm-certificate-arn = module.route53.aws-acm-certificate-arn
  public-zone-id = module.route53.public-zone-id
  depends_on = [module.lambda, module.route53]
}

# module "rds" {
#   source = "./modules/rds"
# }