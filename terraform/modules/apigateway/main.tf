variable "websocket-lambda-arn" {}

resource "aws_apigatewayv2_api" "interview-ace-websocket-api-gateway" {
  name                       = "interview-ace-websicket-api-gateway"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_route" "interview-ace-websocket-route-default" {
  api_id    = aws_apigatewayv2_api.interview-ace-websocket-api-gateway.id
  route_key = "$default"
}

resource "aws_apigatewayv2_route" "interview-ace-websocket-route-connect" {
  api_id    = aws_apigatewayv2_api.interview-ace-websocket-api-gateway.id
  route_key = "$connect"
}

resource "aws_apigatewayv2_route" "interview-ace-websocket-route-disconnect" {
  api_id    = aws_apigatewayv2_api.interview-ace-websocket-api-gateway.id
  route_key = "$disconnect"
}

resource "aws_apigatewayv2_integration" "interview-ace-websocket-connect-integration"{
  api_id           = aws_apigatewayv2_api.interview-ace-websocket-api-gateway.id
  integration_type = "AWS_PROXY"

  connection_type           = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  description               = "Lambda websocket connection integration"
  integration_method        = "POST"
  integration_uri           = var.websocket-lambda-arn
  passthrough_behavior      = "WHEN_NO_MATCH"

  # ADD depends on lambda being created
}