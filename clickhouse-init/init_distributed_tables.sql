CREATE TABLE IF NOT EXISTS graphite_distributed (
  Path String,
  Value Float64,
  Time UInt32,
  Date Date,
  Timestamp UInt32
) ENGINE = Distributed('hmrc_data_cluster', '', 'graphite');

CREATE TABLE IF NOT EXISTS graphite_tree_distributed (
  Date Date,
  Level UInt32,
  Path String,
  Deleted UInt8,
  Version UInt32
) ENGINE = Distributed('hmrc_data_cluster', '', 'graphite_tree');

