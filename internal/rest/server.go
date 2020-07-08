package rest

import (
	"context"
	"fmt"
	"github.com/gorilla/mux"
	"net/http"

	"github.com/rs/zerolog/log"
)

type Server struct {
	port string
}

func NewRestServer(port string) *Server {
	return &Server{
		port: port,
	}
}

func (s *Server) ListenAndServe(ctx context.Context) error {
	log.Info().Msgf("Starting REST server. port=%s", s.port)

	srv := &http.Server{Addr: fmt.Sprintf(":%s", s.port), Handler: s.getRouter()}

	errChan := make(chan error, 1)
	done := make(chan struct{}, 1)

	go func() {
		// always returns error. ErrServerClosed on graceful close
		if err := srv.ListenAndServe(); err != http.ErrServerClosed {
			errChan <- err
		}
	}()

	// Graceful shutdown on cancellation
	go func() {
		select {
		case <-ctx.Done():
			log.Info().Msg("Shutting down Rest server...")
			_ = srv.Shutdown(ctx)
			errChan <- ctx.Err()
		case <-done:
			return
		}
	}()

	err := <-errChan
	return err
}

func (s *Server) getRouter() *mux.Router {
	router := mux.NewRouter()

	router.HandleFunc("/", s.tempPath).Methods(http.MethodGet)

	return router
}

func (s *Server) tempPath(w http.ResponseWriter, _ *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(`{"message": "Hello from ICE -  Infrastructure code engine"}`))
}
