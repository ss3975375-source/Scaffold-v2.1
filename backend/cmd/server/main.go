package main

import (
    "context"
    "database/sql"
    "encoding/json"
    "log"
    "net/http"
    "os"
    "time"

    "github.com/redis/go-redis/v9"
    "github.com/ss3975375-source/ultimate-platform/backend/internal/config"
    "github.com/ss3975375-source/ultimate-platform/backend/internal/db"
)

type healthResponse struct {
    Status  string `json:"status"`
    Service string `json:"service"`
    Version string `json:"version"`
}

type readinessResponse struct {
    Status   string `json:"status"`
    Postgres string `json:"postgres"`
    Redis    string `json:"redis"`
}

func main() {
    ctx := context.Background()
    databaseURL := config.Get("DATABASE_URL", "postgres://app:dev_only_change_me@localhost:5432/ultimate_platform?sslmode=disable")
    redisAddr := config.Get("REDIS_ADDR", "localhost:6379")
    httpAddr := config.Get("HTTP_ADDR", ":8080")

    postgres, err := db.OpenPostgres(ctx, databaseURL)
    if err != nil {
        log.Fatalf("postgres initialization failed: %v", err)
    }
    defer postgres.Close()

    redisClient, err := db.OpenRedis(ctx, redisAddr)
    if err != nil {
        log.Fatalf("redis initialization failed: %v", err)
    }
    defer redisClient.Close()

    mux := http.NewServeMux()

    mux.HandleFunc("GET /health", func(w http.ResponseWriter, r *http.Request) {
        writeJSON(w, http.StatusOK, healthResponse{
            Status: "ok",
            Service: "ultimate-platform-api",
            Version: "0.1.0",
        })
    })

    mux.HandleFunc("GET /ready", func(w http.ResponseWriter, r *http.Request) {
        pgOK := postgres.PingContext(r.Context()) == nil
        redisOK := redisClient.Ping(r.Context()).Err() == nil
        status := http.StatusOK
        overall := "ready"
        if !pgOK || !redisOK {
            status = http.StatusServiceUnavailable
            overall = "not_ready"
        }
        writeJSON(w, status, readinessResponse{
            Status: overall,
            Postgres: serviceStatus(pgOK),
            Redis: serviceStatus(redisOK),
        })
    })

    server := &http.Server{
        Addr:              httpAddr,
        Handler:           mux,
        ReadHeaderTimeout: 5 * time.Second,
        IdleTimeout:       60 * time.Second,
    }

    log.Printf("ultimate-platform-api listening on %s", httpAddr)
    log.Fatal(server.ListenAndServe())
}

func serviceStatus(ok bool) string {
    if ok {
        return "ok"
    }
    return "unavailable"
}

func writeJSON(w http.ResponseWriter, status int, value any) {
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(status)
    if err := json.NewEncoder(w).Encode(value); err != nil {
        log.Printf("write JSON response: %v", err)
    }
}

var _ *sql.DB
var _ *redis.Client
var _ = os.Stdout
