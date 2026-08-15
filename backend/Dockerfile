FROM golang:1.26-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o /todo_app ./cmd/todos

FROM gcr.io/distroless/base-debian11 AS release-stage

WORKDIR /

COPY --from=builder /todo_app /todo_app

EXPOSE 3000

USER nonroot:nonroot

ENTRYPOINT ["/todo_app"]
