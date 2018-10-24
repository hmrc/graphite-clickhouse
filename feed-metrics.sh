#!/usr/bin/env bash

set -euo pipefail

INTERVAL=30
PORTS="2003"

# If this is Linux the netcat cr/lf option is different than on a Mac
if [[ "$(uname)" =~ "GNU/Linux" ]]; then
  NC_KEY=C
fi

while true
do
  RAND_NUM=$((RANDOM % (6) + 1 ))
  echo "local.random.diceroll ${RAND_NUM} `date +%s`"
  for PORT in ${PORTS}; do
    echo "local.random.diceroll ${RAND_NUM} `date +%s`" | nc -"${NC_KEY:-c}" localhost "${PORT}"
  done
  sleep ${INTERVAL}
done
