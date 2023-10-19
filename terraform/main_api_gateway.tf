resource "aws_apigatewayv2_domain_name" "api" {
  domain_name = "api.${var.domain}"
  domain_name_configuration {
    certificate_arn = aws_acm_certificate_validation.default.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api" "lambda" {
  name          = "lambda"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id      = aws_apigatewayv2_api.lambda.id
  name        = "lambda"
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.lambda_api_gateway.arn
    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_api_mapping" "lambda" {
  domain_name = aws_apigatewayv2_domain_name.api.id
  api_id      = aws_apigatewayv2_api.lambda.id
  stage       = aws_apigatewayv2_stage.lambda.id
}

resource "aws_cloudwatch_log_group" "lambda_api_gateway" {
  name              = "/aws/api-gateway/${aws_apigatewayv2_api.lambda.name}"
  retention_in_days = 30
}
