#!/usr/bin/env bash

set -euo pipefail

INTERVAL=5
PORTS="2003"

# If this is Linux the netcat cr/lf option is different than on a Mac
if [[ "$(uname)" =~ "Linux" ]]; then
  NC_KEY=C
fi

while true
do
  for PORT in ${PORTS}; do
    RAND_NUM=$((RANDOM % (10) + 1 ))
    echo "play.somecontainer.diceroll ${RAND_NUM} `date +%s`" | nc -"${NC_KEY:-c}" localhost "${PORT}"
    echo "play.somecontainer.diceroll ${RAND_NUM} `date +%s`"
    RAND_NUM=$((RANDOM % (10) + 1 ))
    echo "play.anothercontainer.diceroll ${RAND_NUM} `date +%s`" | nc -"${NC_KEY:-c}" localhost "${PORT}"
    echo "play.anothercontainer.diceroll ${RAND_NUM} `date +%s`"
    RAND_NUM=$((RANDOM % (10) + 1 ))
    echo "play.thiscontainer.diceroll ${RAND_NUM} `date +%s`" | nc -"${NC_KEY:-c}" localhost "${PORT}"
    echo "play.thiscontainer.diceroll ${RAND_NUM} `date +%s`"
    RAND_NUM=$((RANDOM % (10) + 1 ))
    echo "play.thatcontainer.diceroll ${RAND_NUM} `date +%s`" | nc -"${NC_KEY:-c}" localhost "${PORT}"
    echo "play.thatcontainer.diceroll ${RAND_NUM} `date +%s`"
    RAND_NUM=$((RANDOM % (10) + 1 ))
    echo "play.whatcontainer.diceroll ${RAND_NUM} `date +%s`" | nc -"${NC_KEY:-c}" localhost "${PORT}"
    echo "play.whatcontainer.diceroll ${RAND_NUM} `date +%s`"
  done
  sleep ${INTERVAL}
done
