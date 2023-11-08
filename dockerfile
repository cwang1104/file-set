FROM registry.cn-chengdu.aliyuncs.com/dream0206/golang:alpine AS builder

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    GOFLAGS="-mod=vendor"


WORKDIR /pecker
COPY . .
RUN go env -w GOPROXY=https://goproxy.io,direct \
    && cd cmd \
    && go build -o pecker_back ./*.go

FROM registry.cn-chengdu.aliyuncs.com/dream0206/alpine
WORKDIR /pecker
COPY --from=builder /pecker/cmd/pecker_back /pecker/
COPY --from=builder /pecker/config /pecker/config
VOLUME /data

CMD ["./pecker_back"]
EXPOSE 62001
