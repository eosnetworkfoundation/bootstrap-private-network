#!/usr/bin/env bash

BLOCK_SPAN=${1:-10}
HEAD=$(cleos get info | jq .head_block_num)
let ENDBLOCK=$HEAD+$BLOCK_SPAN
curl -X POST http://127.0.0.1:8888/v1/producer/schedule_snapshot \
  -d "{\"block_spacing\": 1,\
  \"start_block_num\": $HEAD,\
  \"end_block_num\": $ENDBLOCK,\
  \"snapshot_description\": \"Every Block\" }"
