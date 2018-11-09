#!/bin/bash

set -euo pipefail

# The container should be set to restart on a non-zero return value, so it can have another go. This is to cope
# with Zookeeper not being ready yet.
# This script is driven by the CLICKHOUSE_CONFIGS string which is defined in by docker-compose.yaml. For each
# section in CLICKHOUSE_CONFIGS, look for a matching .xml file in /
# If that does not exist, exit non zero
# If we have the file, attempt to fire it into Zookeeper
# Lastly, query Zookeeper and look for all the sections. If any are missing, print the list and exit non-zero,
# otherwise exit gracefully - the container should stop and not restart.

if [ -z "${CLICKHOUSE_CONFIGS}" ]; then
  echo "ERROR CLICKHOUSE_CONFIGS variable is not defined, this script cannot work!"
  sleep 60
  exit 99
fi

ZOOKEEPER_PATH=/zookeeper-3.4.13
ZOOKEEPER_NODE=graphite-clickhouse_zookeeper-1_1

# Returns "no znode" if the znode is not in place
function check_znode(){
  CHK_ZNODE=$(${ZOOKEEPER_PATH}/bin/zkCli.sh -server "${ZOOKEEPER_NODE}":2181 ls /clickhouse/"${1}"|tail -1)
  if [ "${CHK_ZNODE}" = "[]" ]; then
    echo "exists"
  else
    echo "no znode"
  fi
}

for CONFIG in ${CLICKHOUSE_CONFIGS}; do
  if [ -f "/${CONFIG}.xml" ]; then
    if [ "$(check_znode ${CONFIG})" = "no znode" ]; then
      ${ZOOKEEPER_PATH}/bin/zkCli.sh -server "${ZOOKEEPER_NODE}":2181 create "/clickhouse/${CONFIG}" "$(cat /${CONFIG}.xml)"
    else
      echo "/clickhouse/${CONFIG} already exists in Zookeeper"
    fi
  else
    echo "/${CONFIG}.xml file does not exist, not creating ${CONFIG}"
    exit 99
  fi
done

# Check if we have all the components. Otherwise exit with non zero so the container restarts
CHK_COMPLETE=$(
  ${ZOOKEEPER_PATH}/bin/zkCli.sh -server "${ZOOKEEPER_NODE}":2181 ls /clickhouse|tail -1|\
  awk -v configs="${CLICKHOUSE_CONFIGS}" '{
    # Remove the characters that made the input an array, namely [ ] and ,
    gsub(/[\[,]/,"");gsub(/\]/,"")
    split(configs,configs_array)
    split($0,found_znodes)
    # Check for each of the configs_array sections in found_znodes
    for (i in configs_array){
      for (x in found_znodes){
        if(found_znodes[x] == configs_array[i]){
          configs_array[i] = "FOUND"
        }
      }
    }
    # Anything not set to FOUND is not in Zookeeper
    for (y in configs_array){
      if(configs_array[y] != "FOUND"){
        printf("%s ", configs_array[y])
      }
    }
  }'
)
if [ -n "${CHK_COMPLETE}" ]; then
  echo "Exiting with non-zero, could not find: ${CHK_COMPLETE}"
  exit 99
else
  echo "Found required sections '${CLICKHOUSE_CONFIGS}' in Zookeeper, exiting gracefully"
  echo 0
fi
