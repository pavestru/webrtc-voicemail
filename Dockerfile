FROM golang:alpine as builder

ADD . /app/
WORKDIR /app
RUN go get github.com/pion/webrtc/v2
RUN go build -o server.bin .

######

FROM alpine:3
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

COPY --from=builder /app/server.bin /
COPY --from=builder /app/index.html /
CMD ["/server.bin"]

EXPOSE 8080 8100-8200/udp
