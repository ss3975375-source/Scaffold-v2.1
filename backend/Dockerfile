FROM golang:1.24-alpine AS build
WORKDIR /src
COPY go.mod ./
COPY cmd ./cmd
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags='-s -w' -o /out/server ./cmd/server

FROM alpine:3.22
RUN adduser -D -H appuser
USER appuser
COPY --from=build /out/server /server
EXPOSE 8080
ENTRYPOINT ["/server"]
