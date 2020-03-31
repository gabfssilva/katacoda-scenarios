#!/bin/bash

docker run -d=true -p 4575-4576:4575-4576 -e SERVICES=sqs,sns localstack/localstack:latest;