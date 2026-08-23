package main

import (
    "encoding/json"
    "log"
    "net/http"
)

type healthResponse struct {
    Status string `json:"status"`
    Service string `json:"service"`
    Version string `json:"version"`
}

func main() {
    mux := http.NewServeMux()

    mux.HandleFunc("GET /health", func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Type", "application/json")
        _ = json.NewEncoder(w).Encode(healthResponse{
            Status: "ok",
            Service: "ultimate-platform-api",
            Version: "0.1.0",
        })
    })

    server := &http.Server{
        Addr:    ":8080",
        Handler: mux,
    }

    log.Println("ultimate-platform-api listening on :8080")
    log.Fatal(server.ListenAndServe())
}
