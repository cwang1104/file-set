FROM registry.cn-chengdu.aliyuncs.com/dream0206/golang:alpine AS builder

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \


WORKDIR /pecker
COPY . .
RUN go env -w GOPROXY=https://goproxy.io,direct \
    && go build -o pecker_back ./*.go

FROM registry.cn-chengdu.aliyuncs.com/dream0206/alpine
WORKDIR /pecker
COPY --from=builder /pecker/pecker_back /pecker/
VOLUME /data

CMD ["./pecker_back"]
EXPOSE 52001