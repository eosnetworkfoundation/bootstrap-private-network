# get info
ENDPOINT=http://127.0.0.1:34500
/local/eosnetworkfoundation/leap/usr/bin/cleos -u $ENDPOINT get info

# Take Snapshot
curl -X POST ${ENDPOINT}/v1/producer/create_snapshot > /local/eosnetworkfoundation/snapshot.json
cat /local/eosnetworkfoundation/snapshot.json | jq
SNAPSHOT=“”
# Install Spring
curl -L --output /local/eosnetworkfoundation/antelope-spring_1.0.1_amd64.deb https://github.com/AntelopeIO/spring/releases/download/v1.0.1/antelope-spring_1.0.1_amd64.deb 2> /dev/null
mkdir /local/eosnetworkfoundation/spring
dpkg -x /local/eosnetworkfoundation/antelope-spring_1.0.1_amd64.deb /local/eosnetworkfoundation/spring

# Shutdown
ps -u enfuser -f | grep eosbproducer
Kill -15 xxxx
Sleep 5
tail -100 /bigata1/log/eosbproducer.log

# Startup
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
# Watch for transition
tail -f /bigata1/log/spring.log | grep -e 'Transitioning to savanna' -e 'Transition to instant finality' /bigata1/log/spring.log
