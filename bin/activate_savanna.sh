#!/usr/bin/env bash

####
# Once private network is setup and running with legacy consensus algo
# we can switch over to new finality method
# We have three producers we will register new BLS keys
# and submitt them `setfinalizer` will activate Savanna Algorithm
####

ENDPOINT=$1
BPA_PUBLIC_KEY=$2
BPB_PUBLIC_KEY=$3
BPC_PUBLIC_KEY=$4
BPA_PROOF_POSSESION=$5
BPB_PROOF_POSSESION=$6
BPC_PROOF_POSSESION=$7

set -x
# unwindw our three producer finalizer keys and make activating call
cleos --url $ENDPOINT push action eosio setfinalizer "{
  \"finalizer_policy\": {
    \"threshold\": 3,
    \"finalizers\": [
      {
        \"description\": \"bpa\",
        \"weight\": 1,
        \"public_key\": \"${BPA_PUBLIC_KEY}\",
        \"pop\": \"${BPA_PROOF_POSSESION}\"
      },
      {
        \"description\": \"bpb\",
        \"weight\": 1,
        \"public_key\": \"${BPB_PUBLIC_KEY}\",
        \"pop\": \"${BPB_PROOF_POSSESION}\"
      },
      {
        \"description\": \"bpc\",
        \"weight\": 1,
        \"public_key\": \"${BPC_PUBLIC_KEY}\",
        \"pop\": \"${BPC_PROOF_POSSESION}\"
      },
      {
        \"description\": \"bpd\",
        \"weight\": 1,
        \"public_key\": \"${BPD_PUBLIC_KEY}\",
        \"pop\": \"${BPD_PROOF_POSSESION}\"
      }
    ]
  }
}"  -p eosio
