FROM ubuntu:16.04

ARG version=0.8.2

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-get install -y curl build-essential
RUN curl -Lo carbon-clickhouse.tar.gz https://github.com/lomik/carbon-clickhouse/archive/v$version.tar.gz

RUN tar -xvf carbon-clickhouse.tar.gz

RUN curl -Lo go.tar.gz https://dl.google.com/go/go1.11.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"
RUN mv carbon-clickhouse-$version carbon-clickhouse
RUN cd carbon-clickhouse && make
RUN mkdir -p /var/log/carbon-clickhouse/
RUN mkdir -p /data/carbon-clickhouse

ENTRYPOINT /carbon-clickhouse/carbon-clickhouse -config=/etc/carbon-clickhouse/config.conf
