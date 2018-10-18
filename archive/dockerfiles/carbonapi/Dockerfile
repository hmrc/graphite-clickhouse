# Stage: Build
FROM golang:1.8-alpine as builder

ENV VERSION=0.11.0
ENV PATH="/root/go/bin/:${PATH}"

RUN apk --update add git make mercurial pkgconf cairo-dev cairo alpine-sdk

RUN mkdir -p /go/src \
    && cd /go/src    \
    && git clone https://github.com/go-graphite/carbonapi.git

# build carbonapi
WORKDIR /go/src/carbonapi
RUN git checkout ${VERSION}
RUN go get github.com/golang/dep/cmd/dep

RUN make dep
RUN make carbonapi


# Stage: Run
FROM alpine

COPY --from=builder /go/src/carbonapi/carbonapi /sbin/

COPY entrypoint.sh /entrypoint.sh
COPY carbonapi.yaml /etc/carbonapi.yaml

RUN apk --update --no-cache add cairo

EXPOSE 8080
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/sbin/carbonapi", "-config", "/etc/carbonapi.yaml"]
