CREATE TABLE IF NOT EXISTS default.graphite ON CLUSTER hmrc_data_cluster (
  Path String,
  Value Float64,
  Time UInt32,
  Date Date,
  Timestamp UInt32
) ENGINE = GraphiteMergeTree(Date, (Path, Time), 8192, 'graphite_rollup');

CREATE TABLE IF NOT EXISTS default.graphite_tree ON CLUSTER hmrc_data_cluster (
  Date Date,
  Level UInt32,
  Path String,
  Deleted UInt8,
  Version UInt32
) ENGINE = ReplacingMergeTree(Date, (Level, Path), 8192, Version);

CREATE TABLE IF NOT EXISTS graphite_distributed AS default.graphite
ENGINE = Distributed('hmrc_data_cluster', 'default', 'graphite');

CREATE TABLE IF NOT EXISTS graphite_tree_distributed AS default.graphite_tree
ENGINE = Distributed('hmrc_data_cluster', 'default', 'graphite_tree');

