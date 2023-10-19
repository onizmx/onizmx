locals {
  tower_stream = "tower_stream"
}

data "archive_file" "tower_stream" {
  type        = "zip"
  source_file = abspath("${path.module}/../build/lambda/${local.tower_stream}/bootstrap")
  output_path = "bin/${local.tower_stream}.zip"
}

resource "aws_lambda_function" "tower_stream" {
  filename         = data.archive_file.tower_stream.output_path
  role             = aws_iam_role.tower_stream.arn
  function_name    = local.tower_stream
  handler          = local.tower_stream
  architectures    = ["arm64"]
  runtime          = "provided.al2"
  memory_size      = 128
  timeout          = 30
  source_code_hash = data.archive_file.tower_stream.output_base64sha256
}

resource "aws_lambda_permission" "tower_stream" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tower_stream.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_iam_role" "tower_stream" {
  name               = local.tower_stream
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_policy" "tower_stream" {
  name   = local.tower_stream
  policy = data.aws_iam_policy_document.tower_stream.json
}

resource "aws_iam_role_policy_attachment" "tower_stream" {
  role       = aws_iam_role.tower_stream.id
  policy_arn = aws_iam_policy.tower_stream.arn
}

data "aws_iam_policy_document" "tower_stream" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:${var.region}:${local.account_id}:log-group:/aws/lambda/${aws_lambda_function.tower_stream.function_name}:*",
    ]
  }
}

resource "aws_apigatewayv2_integration" "tower_stream" {
  api_id             = aws_apigatewayv2_api.lambda.id
  integration_uri    = aws_lambda_function.tower_stream.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "tower_stream" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "GET /lambda/${local.tower_stream}"
  target    = "integrations/${aws_apigatewayv2_integration.tower_stream.id}"
}

resource "aws_cloudwatch_log_group" "tower_stream" {
  name              = "/aws/lambda/${aws_lambda_function.tower_stream.function_name}"
  retention_in_days = 7
}
