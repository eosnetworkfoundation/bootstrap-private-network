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
BPD_PUBLIC_KEY=$5
BPA_PROOF_POSSESION=$6
BPB_PROOF_POSSESION=$7
BPC_PROOF_POSSESION=$8
BPD_PROOF_POSSESION=$9


# unwindw our three producer finalizer keys and make activating call
echo "{
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
}" > /bigata1/savanna/setfinalizer.json


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

cat /bigata1/savanna/setfinalizer.json | sed 's/PUB_BLS_[A-Za-z0-9_-]*/PUB_BLS_hidden/g' | sed 's/SIG_BLS_[A-Za-z0-9_-]*/SIG_BLS_hidden/g'
