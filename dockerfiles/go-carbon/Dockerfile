# Stage: Build
FROM golang:1.8-alpine as builder


ENV VERSION=v0.10.1

RUN set -x \
    && apk --update add git make


RUN set -x \
    && mkdir -p /go/src \
    && cd /go/src \
    && git clone https://github.com/lomik/go-carbon.git

# build go-carbon
WORKDIR /go/src/go-carbon

RUN git checkout ${VERSION}
RUN make submodules
RUN make



# Stage: Run
FROM alpine

COPY --from=builder /go/src/go-carbon/go-carbon /sbin/

EXPOSE 2003 2004 7002 7007 2003/udp
ENTRYPOINT [ "/sbin/go-carbon" ]
