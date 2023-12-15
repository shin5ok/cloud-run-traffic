FROM golang:1.21

ENV ROOT=/app/src
WORKDIR $ROOT
COPY *.go go.mod go.sum ./
RUN go build -o ./main .

CMD ["./main"]
