# syntax=docker/dockerfile:1
FROM golang:1.24.5-alpine as builder
RUN apk update && \
    apk upgrade && \
    apk --no-cache add git
RUN mkdir /build
ADD . /build/
WORKDIR /build
ARG COMMIT
ARG LASTMOD
RUN echo "INFO: building for $COMMIT on $LASTMOD"
RUN \
    CGO_ENABLED=0 GOOS=linux go build \
    -a \
    -installsuffix cgo \
    -ldflags "-X main.COMMIT=$COMMIT -X main.LASTMOD=$LASTMOD -extldflags '-static'" \
    -o rdap-proxy *.go

FROM scratch
WORKDIR /app
COPY --from=builder /build/rdap-proxy .
COPY rdap-proxy-default.yaml .
WORKDIR /app
ENV PORT 4000
ENTRYPOINT ["./rdap-proxy"]

LABEL org.opencontainers.image.revision=$COMMIT \
      org.opencontainers.image.created=$LASTMOD