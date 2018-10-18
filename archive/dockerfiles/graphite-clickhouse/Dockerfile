FROM golang:alpine as builder

RUN apk --no-cache add make git

RUN mkdir -p /go/src/github.com/lomik;\
    cd /go/src/github.com/lomik ;\
    git clone https://github.com/lomik/graphite-clickhouse.git

WORKDIR /go/src/github.com/lomik/graphite-clickhouse

RUN make

FROM alpine:latest

RUN apk --no-cache add ca-certificates
WORKDIR /

COPY --from=builder /go/src/github.com/lomik/graphite-clickhouse/graphite-clickhouse ./usr/bin/graphite-clickhouse

CMD ["graphite-clickhouse"]
