FROM postgres:9.6

RUN export DEBIAN_FRONTEND=noninteractive \
    && echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > /etc/apt/apt.conf.d/01norecommend \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y curl jq haproxy python-psycopg2 python-yaml python-requests python-six python-pysocks \
        python-dateutil python-pip python-setuptools python-prettytable python-wheel python-psutil python locales \

    ## Make sure we have a en_US.UTF-8 locale available
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \

    && pip install 'python-etcd>=0.4.3,<0.5' click tzlocal cdiff \

    && mkdir -p /home/postgres \
    && chown postgres:postgres /home/postgres \

    # Clean up
    && apt-get remove -y python-pip python-setuptools \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /root/.cache


ENV ETCDVERSION 3.2.3
RUN curl -L https://github.com/coreos/etcd/releases/download/v${ETCDVERSION}/etcd-v${ETCDVERSION}-linux-amd64.tar.gz \
    | tar xz -C /usr/local/bin --strip=1 --wildcards --no-anchored etcd etcdctl

ENV CONFDVERSION 0.11.0
RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v${CONFDVERSION}/confd-${CONFDVERSION}-linux-amd64 > /usr/local/bin/confd \
    && chmod +x /usr/local/bin/confd

ENV PATRONIVERSION 1.3.4
RUN mkdir /tmp/patroni \
	&& curl -L https://github.com/zalando/patroni/archive/v${PATRONIVERSION}.tar.gz \
	| tar xz -C /tmp/patroni --strip=1 \
	&& cd /tmp/patroni  \
	&& mv patroni / \
	&& mv extras/confd /etc/confd \
	&& mv patronictl.py / \
	&& mv patroni.py / \
	&& mv docker/entrypoint.sh / \
	&& cd / \
	&& rm -rf /tmp/patroni

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -y \
    && apt-get install -y build-essential postgresql-server-dev-9.6 libevent-dev unzip libevent-2.0-5 \
#    && apt-mark hold libevent-2.0-5 \
    && mkdir /tmp/bg_mon \

    # download bg_mon
    && curl -L https://github.com/CyberDem0n/bg_mon/archive/master.tar.gz \
    | tar xz -C /tmp/bg_mon --strip=1 \

    # build bg_mon
    && cd /tmp/bg_mon \
    && make USE_PGXS=1 ENABLE_GCOV=1 install \
    && cd / \

    # clean up \
    && apt-get remove -y build-essential postgresql-server-dev-9.6 libevent-dev unzip \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /tmp/bg_mon /var/lib/apt/lists/*


### Setting up a simple script that will serve as an entrypoint
RUN mkdir /data/ && touch /pgpass /patroni.yml \
    && chown postgres:postgres -R /patroni/ /data/ /pgpass /patroni.yml /etc/haproxy /var/run/ /var/lib/ /var/log/

EXPOSE 2379 5432 8008

ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
#ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
#USER postgres
