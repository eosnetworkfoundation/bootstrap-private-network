#!/usr/bin/env bash

NODEOS_A_PORT=8888
NODEOS_B_PORT=5888
NODEOS_C_PORT=6888
NODEOS_D_PORT=7888

for p in $NODEOS_A_PORT $NODEOS_B_PORT $NODEOS_C_PORT $NODEOS_D_PORT; do
  if [ $p == 8888 ]; then printf "Node A Port ->"; fi
  if [ $p == 5888 ]; then printf "Node B Port ->"; fi
  if [ $p == 6888 ]; then printf "Node C Port ->"; fi
  if [ $p == 7888 ]; then printf "Node D Port ->"; fi
  cleos --url http://127.0.0.1:${p} net peers | jq '.[].last_handshake.agent'
  echo
done
