# get info
ENDPOINT=http://127.0.0.1:34500
/local/eosnetworkfoundation/leap/usr/bin/cleos -u $ENDPOINT get info
# check producer schedule
/local/eosnetworkfoundation/leap/usr/bin/cleos -u $ENDPOINT get schedule

# Take Snapshot
curl -X POST ${ENDPOINT}/v1/producer/create_snapshot > /local/eosnetworkfoundation/snapshot.json
cat /local/eosnetworkfoundation/snapshot.json | jq
SNAPSHOT=“”
# Install Spring
curl -L --output /local/eosnetworkfoundation/antelope-spring_1.0.1_amd64.deb \
https://github.com/AntelopeIO/spring/releases/download/v1.0.1/antelope-spring_1.0.1_amd64.deb 2> /dev/null
mkdir /local/eosnetworkfoundation/spring
dpkg -x /local/eosnetworkfoundation/antelope-spring_1.0.1_amd64.deb /local/eosnetworkfoundation/spring


# create BLS Key
/local/eosnetworkfoundation/spring/usr/bin/spring-util bls create key --file /local/eosnetworkfoundation/spring/mybls.key
BLS_PRIVATE_KEY=$(grep Private /local/eosnetworkfoundation/spring/mybls.key | cut -d: -f2 | sed 's/\s//')
BLS_PUBLIC_KEY=$(grep Public /local/eosnetworkfoundation/spring/mybls.key | cut -d: -f2 | sed 's/\s//')
BLS_PROOF_OF_POSSESSION=$(grep Possession /local/eosnetworkfoundation/spring/mybls.key | cut -d: -f2 | sed 's/\s//')

# Prepare our configuration file with BLS KEY information before restart
echo signature-provider = ${BLS_PUBLIC_KEY}=KEY:${BLS_PRIVATE_KEY}
cp /bigata1/savanna/eosbproducer-config.ini /bigata1/savanna/eosbproducer-config.ini.bak
echo signature-provider = ${BLS_PUBLIC_KEY}=KEY:${BLS_PRIVATE_KEY} >> /bigata1/savanna/eosbproducer-config.ini
diff -y /bigata1/savanna/eosbproducer-config.ini /bigata1/savanna/eosbproducer-config.ini.bak

# Shutdown
ps -u enfuser -f | grep eosbproducer
Kill -15 xxxx
Sleep 5
tail -20 /bigata1/log/eosbproducer.log

# double check version
/local/eosnetworkfoundation/spring/usr/bin/nodeos --full-version
# remove old state
rm /bigata1/savanna/eosbproducer/data/state/shared_memory.bin

nohup /local/eosnetworkfoundation/spring/usr/bin/nodeos \
    --snapshot $SNAPSHOT \
    --config /bigata1/savanna/eosbproducer-config.ini \
    --data-dir /bigata1/savanna/eosbproducer/data \
    > /bigata1/log/spring.log 2>&1 &

# check still working
/local/eosnetworkfoundation/spring/usr/bin/cleos -u $ENDPOINT get info

# Wait for will execute MSIGS on Sept 25th 1300 to 1400
# hard fork https://msigviewer.netlify.app/mainnet/proposer.enf/spr1.feature
# new EOS System Contracts https://msigviewer.netlify.app/mainnet/proposer.enf/spr2.contrac
#
# no key we haven't added yet
cleos get table --limit 100 eosio eosio finkeys | jq .rows[] | jq  'select (.finalizer_name=="eosbproducer")'
# add the key
cleos --url $ENDPOINT push action eosio regfinkey "{\"finalizer_name\":\"eosbproducer\", \
                            \"finalizer_key\":\"${BLS_PUBLIC_KEY}\", \
                            \"proof_of_possession\":\"${BLS_PROOF_OF_POSSESSION}\"}" -p eosbproducer
# check key is in
cleos get table --limit 100 eosio eosio finkeys | jq .rows[] | jq  'select (.finalizer_name=="eosbproducer")'
# Watch for transition
tail -f /bigata1/log/spring.log | grep -e 'Transitioning to savanna' -e 'Transition to instant finality'
