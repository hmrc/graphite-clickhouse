CREATE TABLE IF NOT EXISTS default.graphite_distributed (
  Path String,
  Value Float64,
  Time UInt32,
  Date Date,
  Timestamp UInt32
) ENGINE = Distributed('hmrc_data_cluster', '', 'graphite', cityHash64(Path));

CREATE TABLE IF NOT EXISTS default.graphite_tree_distributed (
  Date Date,
  Level UInt32,
  Path String,
  Deleted UInt8,
  Version UInt32
) ENGINE = Distributed('hmrc_data_cluster', '', 'graphite_tree', cityHash64(Path));

