# build stage
FROM golang:1.14 AS build-env
ADD . /src
#disable crosscompiling
ENV CGO_ENABLED=0

#compile linux only
ENV GOOS=linux
RUN cd /src && go get -v -d && go build -ldflags '-w -s' -a -installsuffix cgo -o alertmanager-sns-forwarder

# final stage
FROM gcr.io/distroless/base
LABEL maintainer="o.grodzki@reply.de"
COPY --from=build-env /src/alertmanager-sns-forwarder /
CMD ["/alertmanager-sns-forwarder"]

