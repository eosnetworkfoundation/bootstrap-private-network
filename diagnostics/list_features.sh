#!/bin/env bash

COMMAND=${1:-"UNACTIVATED"}
ENDPOINT=${2:-http://127.0.0.1:8888}
# Get all avalible features

curl -X POST ${ENDPOINT}/v1/producer/get_supported_protocol_features \
| jq -r '.[] | "\(.specification[].value) \(.feature_digest)"' | sort > /tmp/all_features.txt

curl -X POST ${ENDPOINT}/v1/chain/get_activated_protocol_features \
| jq -r '.activated_protocol_features[] | "\(.specification[].value) \(.feature_digest)"' | sort > /tmp/active_features.txt

if [ $COMMAND == "UNACTIVATED" ]; then
  diff /tmp/all_features.txt /tmp/active_features.txt
fi

if [ $COMMAND == "ACTIVE" ]; then
  cat /tmp/active_features.txt
fi

if [ $COMMAND == "ALL" ]; then
  cat /tm;/all_features.txt
fi
