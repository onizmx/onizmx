locals {
  hello_world = "hello_world"
}

data "archive_file" "hello_world" {
  type        = "zip"
  source_file = abspath("${path.module}/../build/lambda/${local.hello_world}/bootstrap")
  output_path = "bin/${local.hello_world}.zip"
}

resource "aws_lambda_function" "hello_world" {
  filename         = data.archive_file.hello_world.output_path
  role             = aws_iam_role.hello_world.arn
  function_name    = local.hello_world
  handler          = local.hello_world
  architectures    = ["arm64"]
  runtime          = "provided.al2"
  memory_size      = 128
  timeout          = 30
  source_code_hash = data.archive_file.hello_world.output_base64sha256
}

resource "aws_lambda_permission" "hello_world" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_iam_role" "hello_world" {
  name               = local.hello_world
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_policy" "hello_world" {
  name   = local.hello_world
  policy = data.aws_iam_policy_document.hello_world.json
}

resource "aws_iam_role_policy_attachment" "hello_world" {
  role       = aws_iam_role.hello_world.id
  policy_arn = aws_iam_policy.hello_world.arn
}

data "aws_iam_policy_document" "hello_world" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:${var.region}:${local.account_id}:log-group:/aws/lambda/${aws_lambda_function.hello_world.function_name}:*",
    ]
  }
}

resource "aws_apigatewayv2_integration" "hello_world" {
  api_id             = aws_apigatewayv2_api.lambda.id
  integration_uri    = aws_lambda_function.hello_world.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "hello_world" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "GET /lambda/${local.hello_world}"
  target    = "integrations/${aws_apigatewayv2_integration.hello_world.id}"
}

resource "aws_cloudwatch_log_group" "hello_world" {
  name              = "/aws/lambda/${aws_lambda_function.hello_world.function_name}"
  retention_in_days = 7
}
