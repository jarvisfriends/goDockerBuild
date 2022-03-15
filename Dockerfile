#FROM golang:1.17.8-alpine
FROM goreleaser/goreleaser

RUN apk add --no-cache bash \
	build-base \
	curl \
	docker-cli \
	docker-cli-buildx \
	git \
    github-cli \
	gpg \
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

# goreleaser doesn't have version numbers in their files which makes it easy to download, even easier we are just basing our container off theirs
#RUN cd /tmp && wget -c https://github.com/goreleaser/goreleaser/releases/latest/download/goreleaser_Linux_x86_64.tar.gz -O - | \
# tar -xz && \
# upx -v -9 ./goreleaser -o /bin/goreleaser

RUN cd /tmp && \
 curl --silent "https://api.github.com/repos/protocolbuffers/protobuf-go/releases/latest" | \
 grep '"tag_name": "v' | grep -o '[[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*' | \
 xargs -I {} wget -c https://github.com/protocolbuffers/protobuf-go/releases/latest/download/protoc-gen-go.v{}.linux.amd64.tar.gz -O - | \
 tar -xz && \
 upx -v -9 ./protoc-gen-go -o /bin/protoc-gen-go \

RUN cd /tmp && \
 curl --silent "https://api.github.com/repos/caarlos0/svu/releases/latest" | \
 grep '"tag_name": "v' | grep -o '[[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*' | \
 xargs -I {} wget -c https://github.com/caarlos0/svu/releases/latest/download/svu_{}_linux_amd64.tar.gz -O - | \
 tar -xz && \
 upx -v -9 ./svu -o /bin/svu

# If Alpine supported the '-P' option then this grep would be a much shorter way to get the version number, \
#   grep -Po '"tag_name": "v\K.*?(?=")'

ENTRYPOINT ["/entrypoint.sh"]
