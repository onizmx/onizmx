package main

import (
	"github.com/aws/aws-lambda-go/lambda"

	"github.com/onizmx/lambda/hello_world/handler"
)

func main() {
	lambdaHandler := handler.NewHelloWorldHandler()
	lambda.Start(lambdaHandler.Run)
}
