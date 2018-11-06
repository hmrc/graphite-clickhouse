# Clickhouse Graphite Metric Cluster

This repository contains a number of docker containers for a Clickhouse cluster using Zookeeper and carbon-clickhouse to
feed metrics. The cluster has two shards, with two containers (replicas) in each shard.

To start the cluster:
```bash
docker-compose up
```

 Container           | Notes
 ------------------- | ----------------
 zookeeper-1         | Used by Clickhouse replication
 zookeeper-2         |
 zookeeper-3         |
 clickhouse-server-1 | Shard 1 replica 1
 clickhouse-server-2 | Shard 1 replica 2
 clickhouse-server-3 | Shard 2 replica 1
 clickhouse-server-4 | Shard 2 replica 2
 clickhouse-init     | Used to run sql to create schemas on each server
 carbon-clickhouse   | A translation layer that is able to take carbon input protocols and write them to clickhouse-server-1

## Loading graphite data

There is a shell script that simulates a dice roll that is sent to carbon-clickhouse every 30 seconds. It only sends
data to the first replica of the first cluster, but it's good enough to demonstrate the concepts of sharding,
replication and distributed tables:
- If you select from testcluster_shard_1.graphite on clickhouse-server-1 the dice roll data will be present.
- If you select from testcluster_shard_1.graphite on clickhouse-server-2 the dice roll data will be present (since it is replicated).
- If you select from testcluster_shard_2.graphite on clickhouse-server-3 or clickhouse-server-4 then no data will be present (since it does not exist in that shard)
- If you select data from graphite_distributed on any container then the data will be returned since distributed tables
look across the whole cluster.

To send data:
```
./feed-metrics.sh
```
