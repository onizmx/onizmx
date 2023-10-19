package handler

import (
	"context"
	"encoding/json"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
)

type TowerStreamHandler interface {
	Run(ctx context.Context, request events.APIGatewayV2HTTPRequest) (events.APIGatewayV2HTTPResponse, error)
}

type towerStreamHandler struct {
}

func NewTowerStreamHandler() TowerStreamHandler {
	return towerStreamHandler{}
}

func (h towerStreamHandler) Run(
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

	blobList := []string{
		"https://comms-tech-test.s3.ap-southeast-2.amazonaws.com/tower_stream/tower-stream-2023-10-19T06%3A58%3A24.613Z.csv",
		"https://comms-tech-test.s3.ap-southeast-2.amazonaws.com/tower_stream/tower-stream-2023-10-19T06%3A58%3A24.657Z.csv",
		"https://comms-tech-test.s3.ap-southeast-2.amazonaws.com/tower_stream/tower-stream-2023-10-19T06%3A58%3A24.695Z.csv",
		"https://comms-tech-test.s3.ap-southeast-2.amazonaws.com/tower_stream/tower-stream-2023-10-19T06%3A58%3A24.746Z.csv",
		"https://comms-tech-test.s3.ap-southeast-2.amazonaws.com/tower_stream/tower-stream-2023-10-19T06%3A58%3A24.773Z.csv",
		"https://comms-tech-test.s3.ap-southeast-2.amazonaws.com/tower_stream/tower-stream-2023-10-19T06%3A58%3A24.860Z.csv",
	}
	data, marshalErr := json.Marshal(blobList)
	if marshalErr != nil {
		response.StatusCode = http.StatusInternalServerError
		response.Body = marshalErr.Error()
		return response, marshalErr
	}
	response.StatusCode = http.StatusOK
	response.Body = string(data)

	return response, nil
}
