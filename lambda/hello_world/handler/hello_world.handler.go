package handler

import (
	"context"
	"encoding/json"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
)

type HelloWorldHandler interface {
	Run(ctx context.Context, request events.APIGatewayV2HTTPRequest) (events.APIGatewayV2HTTPResponse, error)
}

type helloWorldHandler struct {
}

func NewHelloWorldHandler() HelloWorldHandler {
	return helloWorldHandler{}
}

func (h helloWorldHandler) Run(
	ctx context.Context,
	request events.APIGatewayV2HTTPRequest,
) (events.APIGatewayV2HTTPResponse, error) {
	response := events.APIGatewayV2HTTPResponse{
		Headers: map[string]string{
			"Access-Control-Allow-Origin":      "*",
			"Access-Control-Allow-Credentials": "true",
			"Cache-Control":                    "no-cache; no-store",
			"Content-Type":                     "application/json",
			"Content-Security-Policy":          "default-src self",
			"Strict-Transport-Security":        "max-age=31536000; includeSubDomains",
			"X-Content-Type-Options":           "nosniff",
			"X-XSS-Protection":                 "1; mode=block",
			"X-Frame-Options":                  "DENY",
		},
		IsBase64Encoded: false,
	}

	data, marshalErr := json.Marshal(HelloWorldResponse{
		Message: "Hello, World!",
	})
	if marshalErr != nil {
		response.StatusCode = http.StatusInternalServerError
		response.Body = marshalErr.Error()
		return response, marshalErr
	}
	response.StatusCode = http.StatusOK
	response.Body = string(data)

	return response, nil
}
