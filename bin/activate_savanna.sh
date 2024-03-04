#!/usr/bin/env bash

####
# Once private network is setup and running with legacy consensus algo
# we can switch over to new finality method
# We have three producers we will register new BLS keys
# and submitt them `setfinalizer` will activate Savanna Algorithm
####

ENDPOINT=$1
WALLET_DIR=$2

PUBLIC_KEY=()
PROOF_POSSESION=()
# three producers
for producer_name in bpa bpb bpc
do
  leap-util bls create key --to-console > "${WALLET_DIR:?}"/"${producer_name}.finalizer.key"
  PUBLIC_KEY+=( $(grep Public "${WALLET_DIR}"/"${producer_name}.finalizer.key" | cut -d: -f2 | sed 's/ //g') ) \
    || exit 127
  PROOF_POSSESION+=( $(grep Possession "${WALLET_DIR}"/"${producer_name}.finalizer.key" | cut -d: -f2 | sed 's/ //g') ) \
    || exit 127
done

# unwindw our three producer finalizer keys and make activating call
cleos --url $ENDPOINT push action eosio setfinalizer "{
  \"finalizer_policy\": {
    \"threshold\": 3,
    \"finalizers\": [
      {
        \"description\": \"bpa\",
        \"weight\": 1,
        \"public_key\": \"${PUBLIC_KEY[0]}\",
        \"pop\": \"${PROOF_POSSESION[0]}\"
      },
      {
        \"description\": \"bpb\",
        \"weight\": 1,
        \"public_key\": \"${PUBLIC_KEY[1]}\",
        \"pop\": \"${PROOF_POSSESION[1]}\"
      },
      {
        \"description\": \"bpc\",
        \"weight\": 1,
        \"public_key\": \"${PUBLIC_KEY[2]}\",
        \"pop\": \"${PROOF_POSSESION[2]}\"
      }
    ]
  }
}"  -p eosio
