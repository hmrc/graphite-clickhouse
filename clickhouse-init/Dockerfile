FROM ubuntu:16.04

ARG version=18.14.9

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-add-repository -y 'deb http://repo.yandex.ru/clickhouse/deb/stable/ main/'
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E0C56BD4
RUN apt-get update \
    && apt-get install --yes --no-install-recommends --fix-missing\
        apt-transport-https \
        dirmngr \
        gnupg \
        zookeeper \
        python-pip \
	netcat
RUN DEBIAN_FRONTEND=noninteractive \
                apt-get install --allow-unauthenticated --yes --no-install-recommends \
                    clickhouse-common-static=$version \
                    clickhouse-client=$version
RUN pip install setuptools
RUN pip install --no-cache-dir envtpl

ENTRYPOINT ["/usr/bin/clickhouse-client"]

