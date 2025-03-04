#!/bin/bash

SONAR_HOST_URL=http://localhost:9090
SONAR_TOKEN=<your_token>
SONAR_SCANNER_OPTS="-Dsonar.sources=app"

docker run \
    --rm \
    --network="host" \
    -e SONAR_HOST_URL=$SONAR_HOST_URL  \
    -e SONAR_TOKEN=$SONAR_TOKEN \
    -e SONAR_SCANNER_OPTS="$SONAR_SCANNER_OPTS" \
    -v "$PWD:/usr/src" \
    sonarsource/sonar-scanner-cli
