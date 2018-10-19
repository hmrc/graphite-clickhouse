CREATE TABLE graphite (
  Path String,
  Value Float64,
  Time UInt32,
  Date Date,
  Timestamp UInt32
) ENGINE = ReplicatedGraphiteMergeTree('/clickhouse/tables/{layer}-{shard}/hits', '{replica}', Date, (Path, Time), 8192, 'graphite_rollup');

-- optional table for faster metric search
CREATE TABLE graphite_tree (
  Date Date,
  Level UInt32,
  Path String,
  Deleted UInt8,
  Version UInt32
) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{layer}-{shard}/hits', '{replica}', Date, (Level, Path), 8192, Version);
