CREATE DATABASE IF NOT EXISTS metrics;

CREATE TABLE IF NOT EXISTS metrics.graphite (
  Path String,
  Value Float64,
  Time UInt32,
  Date Date,
  Timestamp UInt32
) ENGINE = GraphiteMergeTree(Date, (Path, Time), 8192, 'graphite_rollup');

-- optional table for faster metric search
CREATE TABLE IF NOT EXISTS metrics.graphite_tree (
  Date Date,
  Level UInt32,
  Path String,
  Deleted UInt8,
  Version UInt32
) ENGINE = ReplacingMergeTree(Date, (Level, Path), 8192, Version);

CREATE TABLE IF NOT EXISTS default.graphite AS metrics.graphite
ENGINE = Distributed('hmrc_data_cluster', 'metrics', 'graphite');

CREATE TABLE IF NOT EXISTS default.graphite_tree AS metrics.graphite_tree
ENGINE = Distributed('hmrc_data_cluster', 'metrics', 'graphite_tree');

