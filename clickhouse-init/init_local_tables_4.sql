CREATE TABLE IF NOT EXISTS testcluster_shard_2.graphite (
  Path String,
  Value Float64,
  Time UInt32,
  Date Date,
  Timestamp UInt32
) ENGINE = ReplicatedGraphiteMergeTree('/clickhouse/tables/testcluster_shard_2/graphite', 'replica_2', 'graphite_rollup')
PARTITION BY toMonday(Date)
ORDER BY (Path, Time);

-- optional table for faster metric search
CREATE TABLE IF NOT EXISTS testcluster_shard_2.graphite_tree (
  Date Date,
  Level UInt32,
  Path String,
  Deleted UInt8,
  Version UInt32
) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/testcluster_shard_2/graphite_tree', 'replica_2', 'graphite_rollup')
ORDER BY (Level, Path);

