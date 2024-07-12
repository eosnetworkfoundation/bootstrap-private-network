#!/usr/bin/env bash

ENDPOINT=$1
WALLET_DIR=$2

BPA_PUBLIC_KEY=$(grep Public "$WALLET_DIR/bpa.keys" | head -1 | cut -d: -f2 | sed 's/ //g')
cleos --url $ENDPOINT create account eosio bpa $BPA_PUBLIC_KEY $BPA_PUBLIC_KEY --max-cpu-usage-ms 0 --max-net-usage 0
BPB_PUBLIC_KEY=$(grep Public "$WALLET_DIR/bpb.keys" | head -1 | cut -d: -f2 | sed 's/ //g')
cleos --url $ENDPOINT create account eosio bpb $BPB_PUBLIC_KEY $BPB_PUBLIC_KEY --max-cpu-usage-ms 0 --max-net-usage 0
BPC_PUBLIC_KEY=$(grep Public "$WALLET_DIR/bpc.keys" | head -1 | cut -d: -f2 | sed 's/ //g')
cleos --url $ENDPOINT create account eosio bpc $BPC_PUBLIC_KEY $BPC_PUBLIC_KEY --max-cpu-usage-ms 0 --max-net-usage 0
BPD_PUBLIC_KEY=$(grep Public "$WALLET_DIR/bpd.keys" | head -1 | cut -d: -f2 | sed 's/ //g')
cleos --url $ENDPOINT create account eosio bpd $BPD_PUBLIC_KEY $BPD_PUBLIC_KEY --max-cpu-usage-ms 0 --max-net-usage 0

cleos --url $ENDPOINT_ONE transfer eosio bpa "10000 EOS" "init funding"
cleos --url $ENDPOINT_ONE transfer eosio bpb "10000 EOS" "init funding"
cleos --url $ENDPOINT_ONE transfer eosio bpc "10000 EOS" "init funding"

cleos --url $ENDPOINT push action eosio setprods "{
    \"schedule\":[
        {
          \"producer_name\": \"bpa\",
          \"authority\": [
            \"block_signing_authority_v0\",{
              \"threshold\": 1,
              \"keys\": [{
                  \"key\": \"$BPA_PUBLIC_KEY\",
                  \"weight\": 1
                }
              ]
            }
          ]
        },
        {
          \"producer_name\": \"bpb\",
          \"authority\": [
            \"block_signing_authority_v0\",{
              \"threshold\": 1,
              \"keys\": [{
                  \"key\": \"$BPB_PUBLIC_KEY\",
                  \"weight\": 1
                }
              ]
            }
          ]
        },
        {
          \"producer_name\": \"bpc\",
          \"authority\": [
            \"block_signing_authority_v0\",{
              \"threshold\": 1,
              \"keys\": [{
                  \"key\": \"$BPC_PUBLIC_KEY\",
                  \"weight\": 1
                }
              ]
            }
          ]
        },
        {
          \"producer_name\": \"bpd\",
          \"authority\": [
            \"block_signing_authority_v0\",{
              \"threshold\": 1,
              \"keys\": [{
                  \"key\": \"$BPD_PUBLIC_KEY\",
                  \"weight\": 1
                }
              ]
            }
          ]
        }
    ]
}" -p eosio@active
