FROM gcc:latest

ENV VERSION=1.13.3
ENV OPENSSL_VERSION=1.0.2l

RUN apt-get install libxslt1-dev libxml2-dev zlib1g-dev libpcre3-dev libbz2-dev libssl-dev
RUN cd /tmp; wget http://nginx.org/download/nginx-${VERSION}.tar.gz
RUN cd /tmp; tar xfvz nginx-${VERSION}.tar.gz

WORKDIR /tmp/nginx-${VERSION}

RUN wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
RUN tar xfvz openssl-${OPENSSL_VERSION}.tar.gz

RUN ./configure  --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_realip_module \
        --with-http_gzip_static_module \
        --without-http_scgi_module  \
        --without-http_uwsgi_module  \
        --without-http_fastcgi_module \
        --with-openssl=./openssl-${OPENSSL_VERSION} \
        --prefix=/opt/nginx \
        --conf-path=/opt/nginx/etc/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-client-body-temp-path=/tmp/nginx_body \
        --http-log-path=/var/log/nginx/access.log \
        --http-proxy-temp-path=/tmp/nginx_proxy \
        --lock-path=/var/lock/nginx.lock \
        --pid-path=/var/run/nginx.pid \
        --with-ld-opt="-Bstatic -static -static-libgcc -static-libstdc++ -pthread"


# with -j > 1 nginx's tries to link openssl before it gets built
RUN make -j1
RUN make install


FROM frolvlad/alpine-glibc

COPY --from=0 /opt/ /opt/
RUN mkdir -p mkdir -p /var/log/nginx

