CREATE TABLE IF NOT EXISTS default.graphite ON CLUSTER hmrc_data_cluster (
  Path String,
  Value Float64,
  Time UInt32,
  Date Date,
  Timestamp UInt32
) ENGINE = ReplicatedGraphiteMergeTree('/clickhouse/tables/{shard1}/graphite', '{replica1}', 'graphite_rollup')
PARTITION BY toMonday(Date)
ORDER BY (Path, Time);

CREATE TABLE IF NOT EXISTS default.graphite_tree ON CLUSTER hmrc_data_cluster (
  Date Date,
  Level UInt32,
  Path String,
  Deleted UInt8,
  Version UInt32
) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{shard1}/graphite_tree', '{replica1}', 'graphite_rollup')
ORDER BY (Level, Path);

CREATE TABLE IF NOT EXISTS graphite_distributed AS default.graphite
ENGINE = Distributed('hmrc_data_cluster', 'default', 'graphite');

CREATE TABLE IF NOT EXISTS graphite_tree_distributed AS default.graphite_tree
ENGINE = Distributed('hmrc_data_cluster', 'default', 'graphite_tree');

