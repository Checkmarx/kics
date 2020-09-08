package rest

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/checkmarxDev/ice/internal/correlation"
	"github.com/checkmarxDev/ice/internal/logger"
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
	corrID := correlation.FromHTTPRequest(r)
	ctx := correlation.AddToContext(r.Context(), corrID)

	scanID := mux.Vars(r)["scan-id"]

	logger.GetLoggerWithFieldsFromContext(ctx).
		Trace().
		Str("scanID", scanID).
		Msg("rest api. getting scan results")

	results, err := s.Service.GetResults(ctx, scanID)
	if err != nil {
		logger.GetLoggerWithFieldsFromContext(ctx).
			Err(err).
			Str("scanID", scanID).
			Msg("rest api. failed to get results for scan")

		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	if encodeErr := json.NewEncoder(w).Encode(results); encodeErr != nil {
		logger.GetLoggerWithFieldsFromContext(ctx).
			Err(encodeErr).
			Msg("rest api. failed encoding and returning results")
	}
}
