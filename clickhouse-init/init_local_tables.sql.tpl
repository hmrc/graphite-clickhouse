CREATE TABLE IF NOT EXISTS default.graphite (
  Path String,
  Value Float64,
  Time UInt32,
  Date Date,
  Timestamp UInt32
) ENGINE = ReplicatedGraphiteMergeTree('/clickhouse/tables/testcluster_shard_{{ THIS_SHARD }}/graphite', 'replica_{{ THIS_REPLICA }}', 'graphite_rollup')
PARTITION BY toMonday(Date)
ORDER BY (Path, Time);

-- optional table for faster metric search
CREATE TABLE IF NOT EXISTS default.graphite_tree (
  Date Date,
  Level UInt32,
  Path String,
  Deleted UInt8,
  Version UInt32
) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/testcluster_shard_{{ THIS_SHARD }}/graphite_tree', 'replica_{{ THIS_REPLICA }}', 'graphite_rollup')
ORDER BY (Level, Path);
