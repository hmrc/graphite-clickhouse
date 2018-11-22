#!/bin/bash

set -euo pipefail

if [ -z "${CLICKHOUSE_CONFIGS}" ]; then
  echo "ERROR CLICKHOUSE_CONFIGS variable is not defined, this script cannot work!"
  sleep 60
  exit 99
fi

function get_replica(){
  echo $([ $(expr $1 % 2 + 1) == 1 ] && echo 2 || echo 1)
}

function get_shard(){
  echo $(expr $(expr 1 + $1) / 2)
}

ZOOKEEPER_PATH=/usr/share/zookeeper
ZOOKEEPER_NODE=graphite-clickhouse_zookeeper-1_1

# Check that all sections in ZOOKEEPER_CONFIGS exist in Zookeeper

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
  echo "Found required sections '${CLICKHOUSE_CONFIGS}' in Zookeeper, we can continue"
fi


# Get the number of clickhouse-servers

SERVER_LIST=$(${ZOOKEEPER_PATH}/bin/zkCli.sh -server "${ZOOKEEPER_NODE}":2181 get /clickhouse/remote_servers | 
awk '/<host>.+<\/host>$/{ sub(".*<host>", ""); sub("</host>$", ""); print $0 }')

# Loop around numbers
COUNTER=1
for SERVER in $SERVER_LIST; do
  
  nc -z -w 4 -v $SERVER 9000

  if [ $? -ne 0 ]; then
    echo "Can't connect to $SERVER, exiting non-zero.."
    exit 99
  fi

  THIS_SHARD=$(get_shard ${COUNTER})
  THIS_REPLICA=$(get_replica ${COUNTER})

  echo "Templating server number $COUNTER, host $SERVER.. shard:$THIS_SHARD replica:$THIS_REPLICA"

  # Create create_database.sql
  THIS_SHARD=${THIS_SHARD} \
      envtpl -o /create_database.sql \
      --keep-template \
      /create_database.sql.tpl
  if [ $? -ne 0 ]; then 
      echo "envtpl failed, exiting non-zero"
      exit 99
  fi

  # Create local_tables.sql
  THIS_SHARD=${THIS_SHARD} \
      THIS_REPLICA=${THIS_REPLICA} \
      envtpl -o /init_local_tables.sql \
      --keep-template \
      /init_local_tables.sql.tpl
  if [ $? -ne 0 ]; then 
      echo "envtpl failed, exiting non-zero"
      exit 99
  fi

  # Check all files were created and run them
  for FILE in create_database.sql init_local_tables.sql init_distributed_tables.sql table_exists_test.sql; do
    if [ "$(cat /$FILE | wc -l)" -gt 0 ]; then
      echo "$FILE is non-empty, running it.."
    else 
      echo "$FILE is empty so templating failed, exiting.."
      exit 99
    fi 
    # test to ensure corect number of tables have been created
    if [ "$FILE" == "table_exists_test.sql" ]; then
	    if [ "$(cat /$FILE | clickhouse client --host ${SERVER} --multiquery --progress)" -ne 4 ]; then
	      echo "4 tables have not been created, exiting.."
	      exit 99
	    else
	      echo "4 tables have been created.."
	    fi
    else
  	  cat /$FILE | clickhouse client --host ${SERVER} --multiquery --progress
    fi
  done

  COUNTER=$(expr $COUNTER + 1)
done

