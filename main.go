package main

import (
	"log"
	"net/http"
	"os"
	"time"

	"github.com/go-chi/chi/v5"
)

var (
	version       = os.Getenv("VERSION")
	versionString string
)

func init() {
	if version == "" {
		version = time.Now().String()
	}
	versionString = "version: " + version
}

func main() {
	r := chi.NewRouter()
	r.Get("/version", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte(versionString + "\n"))
		log.Println(versionString)
	})
	http.ListenAndServe(":8080", r)
}
