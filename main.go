package main

import (
	"log/slog"
	"net/http"
	"os"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
)

var (
	version       = os.Getenv("VERSION")
	cloudRunRev   = os.Getenv("K_REVISION")
	port          = os.Getenv("PORT")
	versionString string
	logger        *slog.Logger
	instanceID    string
)

func init() {
	if version == "" {
		version = time.Now().String()
	}
	instanceID = uuid.New().String()
	versionString = "version: " + version
}

func init() {

	replace := func(groups []string, a slog.Attr) slog.Attr {
		if a.Key == slog.LevelKey && a.Value.String() == slog.LevelWarn.String() {
			return slog.String("severity", "WARNING")
		}
		if a.Key == "level" {
			return slog.String("severity", a.Value.String())
		}
		if a.Key == "msg" {
			return slog.String("message", a.Value.String())
		}
		return a
	}

	options := slog.HandlerOptions{
		Level:     slog.LevelInfo,
		AddSource: true, ReplaceAttr: replace,
	}

	logger = slog.New(slog.NewJSONHandler(os.Stdout, &options))
	slog.SetDefault(logger)

}

func main() {
	r := chi.NewRouter()

	r.Get("/version", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte(versionString + "\n"))
		logger.Info("api version",
			"version", versionString,
			"revision", cloudRunRev,
			"instance", instanceID,
		)
		// log.Printf("id: %s, revision:%s, version: %s\n", instanceID, cloudRunRev, versionString)
	})

	if port == "" {
		port = "8080"
	}
	http.ListenAndServe(":"+port, r)
}
