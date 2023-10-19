package main

import (
	"github.com/aws/aws-lambda-go/lambda"

	"github.com/onizmx/lambda/tower_stream/handler"
)

func main() {
	lambdaHandler := handler.NewTowerStreamHandler()
	lambda.Start(lambdaHandler.Run)
}
