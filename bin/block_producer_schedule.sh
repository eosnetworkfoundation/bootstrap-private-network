#!/usr/bin/env bash

ENDPOINT=$1
PUBLIC_KEY=$2

cleos --url $ENDPOINT create account eosio bpa $PUBLIC_KEY $PUBLIC_KEY --max-cpu-usage-ms 0 --max-net-usage 0
cleos --url $ENDPOINT create account eosio bpb $PUBLIC_KEY $PUBLIC_KEY --max-cpu-usage-ms 0 --max-net-usage 0
cleos --url $ENDPOINT create account eosio bpc $PUBLIC_KEY $PUBLIC_KEY --max-cpu-usage-ms 0 --max-net-usage 0

cleos --url $ENDPOINT push action eosio setprods "{
    \"schedule\":[
        {
          \"producer_name\": \"bpa\",
          \"authority\": [
            \"block_signing_authority_v0\",{
              \"threshold\": 1,
              \"keys\": [{
                  \"key\": \"$PUBLIC_KEY\",
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
                  \"key\": \"$PUBLIC_KEY\",
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
                  \"key\": \"$PUBLIC_KEY\",
                  \"weight\": 1
                }
              ]
            }
          ]
        }
    ]
}" -p eosio@active
