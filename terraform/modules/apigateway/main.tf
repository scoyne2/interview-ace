variable "websocket-lambda-arn" {}
variable "websocket-function-name" {}
variable "aws-acm-certificate-arn" {}
variable "public-zone-id" {}

resource "aws_apigatewayv2_api" "interview-ace-websocket-api-gateway" {
  name                       = "interview-ace-websocket-api-gateway"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
  version                    = "1.0.0"
}

# domain name
resource "aws_apigatewayv2_domain_name" "api" {
  domain_name = "websocket.crackingthedataengineeringinterview.com"

  domain_name_configuration {
    certificate_arn = var.aws-acm-certificate-arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

}

resource "aws_route53_record" "api" {
  name    = aws_apigatewayv2_domain_name.api.domain_name
  type    = "A"
  zone_id = var.public-zone-id

  alias {
    name                   = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_apigatewayv2_integration" "interview-ace-websocket-integration"{
  api_id           = aws_apigatewayv2_api.interview-ace-websocket-api-gateway.id
  integration_type = "AWS_PROXY"

  connection_type           = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  description               = "Lambda websocket integration"
  integration_method        = "POST"
  integration_uri           = var.websocket-lambda-arn
  passthrough_behavior      = "WHEN_NO_MATCH"

  depends_on = [ aws_apigatewayv2_api.interview-ace-websocket-api-gateway ]
}

# default route
resource "aws_apigatewayv2_route" "interview-ace-websocket-route-default" {
  api_id    = aws_apigatewayv2_api.interview-ace-websocket-api-gateway.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.interview-ace-websocket-integration.id}"

  depends_on = [ aws_apigatewayv2_integration.interview-ace-websocket-integration ]
}

resource "aws_apigatewayv2_route_response" "interview-ace-websocket-route-response-default" {
  api_id             = aws_apigatewayv2_api.interview-ace-websocket-api-gateway.id
  route_id           = aws_apigatewayv2_route.interview-ace-websocket-route-default.id
  route_response_key = "$default"

  depends_on = [ aws_apigatewayv2_route.interview-ace-websocket-route-default ]
}

# connect route
resource "aws_apigatewayv2_route" "interview-ace-websocket-route-connect" {
  api_id    = aws_apigatewayv2_api.interview-ace-websocket-api-gateway.id
  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.interview-ace-websocket-integration.id}"
}

resource "aws_apigatewayv2_route_response" "interview-ace-websocket-route-response-connect" {
  api_id             = aws_apigatewayv2_api.interview-ace-websocket-api-gateway.id
  route_id           = aws_apigatewayv2_route.interview-ace-websocket-route-connect.id
  route_response_key = "$default"

  depends_on = [ aws_apigatewayv2_route.interview-ace-websocket-route-connect ]
}

# disconnect route
resource "aws_apigatewayv2_route" "interview-ace-websocket-route-disconnect" {
  api_id    = aws_apigatewayv2_api.interview-ace-websocket-api-gateway.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.interview-ace-websocket-integration.id}"

  depends_on = [ aws_apigatewayv2_integration.interview-ace-websocket-integration ]
}

resource "aws_apigatewayv2_route_response" "interview-ace-websocket-route-response-disconnect" {
  api_id             = aws_apigatewayv2_api.interview-ace-websocket-api-gateway.id
  route_id           = aws_apigatewayv2_route.interview-ace-websocket-route-disconnect.id
  route_response_key = "$default"

  depends_on = [ aws_apigatewayv2_route.interview-ace-websocket-route-disconnect ]
}

resource "aws_lambda_permission" "interview-ace-websocket-lambda-trigger" {
     statement_id  = "AllowAllowLambdaInvokee"
     action        = "lambda:InvokeFunction"
     function_name = var.websocket-function-name
     principal     = "apigateway.amazonaws.com"
     source_arn    = "${aws_apigatewayv2_api.interview-ace-websocket-api-gateway.execution_arn}/*"
}

# stage
resource "aws_apigatewayv2_stage" "interview-ace-websocket-api-gateway-stage" {
  api_id             = aws_apigatewayv2_api.interview-ace-websocket-api-gateway.id
  name               = "production"
  auto_deploy        = true

  default_route_settings {
    data_trace_enabled     = true
    logging_level          = "INFO"
    throttling_rate_limit  = 100
    throttling_burst_limit = 50
  }
}

# deployment
resource "aws_apigatewayv2_deployment" "interview-ace-websocket-api-gateway-deployment" {
  api_id      = aws_apigatewayv2_api.interview-ace-websocket-api-gateway.id
  description = "Interview Ace Websocket API deployment"
  depends_on = [ aws_apigatewayv2_stage.interview-ace-websocket-api-gateway-stage ]

  lifecycle {
    create_before_destroy = true
  }
}

# mapping
resource "aws_apigatewayv2_api_mapping" "interview-ace-websocket-api-mapping" {
  api_id      = aws_apigatewayv2_api.interview-ace-websocket-api-gateway.id
  domain_name = aws_apigatewayv2_domain_name.api.id
  stage       = aws_apigatewayv2_stage.interview-ace-websocket-api-gateway-stage.id
}
