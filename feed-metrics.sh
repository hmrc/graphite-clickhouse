#!/usr/bin/env bash

set -euxo pipefail

while true
do
  echo "local.random.diceroll `((RANDOM % (6) + 1 ))` `date +%s`" | nc -c localhost 2003
  sleep 1
done
