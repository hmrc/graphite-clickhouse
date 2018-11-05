#!/bin/bash

set -euo pipefail

ZOOKEEPER_PATH=/zookeeper-3.4.13

# ${ZOOKEEPER_PATH}/bin/zkCli.sh -server graphite-clickhouse_zookeeper-1_1:2181 rmr /clickhouse/remote_servers
${ZOOKEEPER_PATH}/bin/zkCli.sh -server graphite-clickhouse_zookeeper-1_1:2181 create /clickhouse/remote_servers "$(cat /install/remote_servers.xml)"
${ZOOKEEPER_PATH}/bin/zkCli.sh -server graphite-clickhouse_zookeeper-1_1:2181 create /clickhouse/remote_servers "$(cat /install/remote_servers.xml)"
