FROM alpine:3.18.6

RUN apk upgrade --no-cache && \
 apk add --no-cache \
 bash \
 curl \
 docker-cli \
 docker-cli-buildx \
 gcc \
 git \
 go \
 gpg \
 jq \
 libpcap-dev \
 make \
 musl-dev \
 ncdu \
 openssh-client \
 protobuf-dev \
 protoc \
 tini \
 upx

ENV GOPATH=/go
ENV PATH=${GOPATH}/bin:${PATH}

COPY ./entrypoint.sh /entrypoint.sh

# svu allows us to increment version numbers easily, for instance git tags
RUN chmod +x /entrypoint.sh && \
 go install -ldflags "-s -w" google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
 go install -ldflags "-s -w" google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest && \
 go install -ldflags "-s -w" github.com/goreleaser/goreleaser@latest && \
 go install -ldflags "-s -w" github.com/caarlos0/svu@latest && \
 upx -v -9 ${GOPATH}/bin/protoc-gen-go && \
 upx -v -9 ${GOPATH}/bin/protoc-gen-go-grpc && \
 upx -v -9 ${GOPATH}/bin/goreleaser && \
 upx -v -9 ${GOPATH}/bin/svu && \
 go clean -cache -modcache

ENTRYPOINT ["/sbin/tini", "/entrypoint.sh"]
