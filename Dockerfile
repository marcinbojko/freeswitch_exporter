# build (runs natively on the build host and cross-compiles for the target platform)
FROM --platform=$BUILDPLATFORM golang:1.20 AS builder

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=dev

WORKDIR /go/src
COPY . /go/src/
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH \
    go build -trimpath -ldflags "-s -w -X main.version=${VERSION}" -o freeswitch_exporter

# run
FROM scratch

COPY --from=builder /go/src/freeswitch_exporter /freeswitch_exporter

LABEL author="ZhangLianjun <z0413j@outlook.com>"

EXPOSE 9282
ENTRYPOINT [ "/freeswitch_exporter" ]
