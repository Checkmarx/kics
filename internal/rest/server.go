package rest

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/checkmarxDev/ice/pkg/ice"
	"github.com/gorilla/mux"

	"github.com/rs/zerolog/log"
)

type Server struct {
	Port    string
	Service *ice.Service
}

func (s *Server) ListenAndServe(ctx context.Context) error {
	log.Info().Msgf("Starting REST server. Port=%s", s.Port)

	srv := &http.Server{Addr: fmt.Sprintf(":%s", s.Port), Handler: s.getRouter()}

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

	router.HandleFunc("/results/{scan-id}", s.getResults).Methods(http.MethodGet)

	return router
}

func (s *Server) getResults(w http.ResponseWriter, r *http.Request) {
	scanID := mux.Vars(r)["scan-id"]

	results, err := s.Service.GetResults(context.Background(), scanID)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	if encodeErr := json.NewEncoder(w).Encode(results); encodeErr != nil {
		log.Error().Err(encodeErr).Msg("Failed encoding and returning results")
	}
}
