# Quick Start
```sh
docker-compose up
```

Forked then https://github.com/lomik/graphite-clickhouse-tldr and then changed quite a bit.
documentation has not caught up yet.




## Mapped Ports

Host | Container | Service
---- | --------- | -------------------------------------------------------------------------------------------------------------------
  80 |        80 | [nginx](https://www.nginx.com/resources/admin-guide/)
2003 |      2003 | [carbon receiver - plaintext](http://graphite.readthedocs.io/en/latest/feeding-carbon.html#the-plaintext-protocol)
2004 |      2004 | [carbon receiver - pickle](http://graphite.readthedocs.io/en/latest/feeding-carbon.html#the-pickle-protocol)
2006 |      2006 | [carbon receiver - prometheus remote write](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#%3Cremote_write%3E)
3000 |      3000 | Grafana

## Loading with haggar

Where <<IP_ADDRESS>> is your local machine address (127.0.0.1 does not work on macs)

```
docker run -it egaillardon/haggar -carbon <<IP_ADRESS>>:2003 -agents 10 -metrics 100
```

