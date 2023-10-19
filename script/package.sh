#!/bin/bash

set -eo pipefail

for dir in "$(pwd)"/lambda/*/; do
  BUILD_DIR="${dir}/../../build/lambda"
  LAMBDA_DIR="${dir%*/}"
  LAMBDA_HANDLER="${LAMBDA_DIR##*/}"

  cd "${LAMBDA_DIR}" || exit
  go get && GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -tags lambda.norpc -o "${BUILD_DIR}/${LAMBDA_HANDLER}/bootstrap"
  cd "${BUILD_DIR}" || exit
done
