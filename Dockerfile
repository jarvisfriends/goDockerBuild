FROM goreleaser/goreleaser

RUN apk add --no-cache bash \
 build-base \
 curl \
 docker-cli \
 docker-cli-buildx \
 git \
 github-cli \
 gpg \
 jq \
 make \
 mercurial \
 tini \
 gcc \
 go \
 musl-dev \
 protobuf-dev \
 protoc \
 upx

ENV PATH=/go/bin:${PATH}

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
 go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest && \
 upx -v -9 ${GOPATH}/bin/protoc-gen-go && \
 upx -v -9 ${GOPATH}/bin/protoc-gen-go-grpc

#RUN cd /tmp && \
# curl --silent "https://api.github.com/repos/protocolbuffers/protobuf-go/releases/latest" | \
# grep '"tag_name": "v' | grep -o '[[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*' | \
# xargs go install google.golang.org/protobuf/cmd/protoc-gen-go@ -O - | \
# tar -xz && \
# upx -v -9 ./protoc-gen-go -o /bin/protoc-gen-go \

# Extracting and compressing svu, svu allows us to increment version numbers easily, for instance git tags
#RUN cd /tmp && \
# curl --silent "https://api.github.com/repos/caarlos0/svu/releases/latest" | \
# grep '"tag_name": "v' | grep -o '[[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*' | \
# xargs -I {} wget -c https://github.com/caarlos0/svu/releases/latest/download/svu_{}_linux_amd64.tar.gz -O - | \
# tar -xz && \
# upx -v -9 ./svu -o /bin/svu

# If Alpine supported the '-P' option then this grep would be a much shorter way to get the version number, \
#   grep -Po '"tag_name": "v\K.*?(?=")'

ENTRYPOINT ["/entrypoint.sh"]
