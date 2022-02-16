# Based on upstream Dockerfile https://github.com/go-spatial/tegola/blob/v0.14.x/Dockerfile
FROM golang:1.16.2-alpine3.12 AS build

ARG VERSION="Version Not Set"
ENV VERSION="${VERSION}"

# Only needed for CGO support at time of build, results in no noticable change in binary size
# incurs approximately 1:30 extra build time (1:54 vs 0:27) to install packages.  Doesn't impact
# development as these layers are drawn from cache after the first build.
RUN apk update \
	&& apk add musl-dev=1.1.24-r10 \
	&& apk add gcc=9.3.0-r2 \
	&& apk add git

# Set up source for compilation
RUN mkdir -p /go/src/github.com/go-spatial/tegola
RUN git clone "https://gerrit.wikimedia.org/r/operations/software/tegola" /go/src/github.com/go-spatial/tegola

# Build binary
RUN cd /go/src/github.com/go-spatial/tegola/cmd/tegola \
 	&& go build -v -ldflags "-w -X 'github.com/go-spatial/tegola/cmd/tegola/cmd.Version=${VERSION}'" -gcflags "-N -l" -o /opt/tegola \
	&& chmod a+x /opt/tegola

# Create minimal deployment image, just alpine & the binary
FROM python:3-alpine3.12

RUN apk update \
	&& apk add ca-certificates \
	&& apk add git \
	&& rm -rf /var/cache/apk/*

RUN pip install "git+https://github.com/wikimedia/poppy-cli@dequeue-until-empty" \
    redis \
    kafka-python

COPY --from=build /opt/tegola /opt/
WORKDIR /opt
ENTRYPOINT ["/opt/tegola"]
