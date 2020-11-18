package rest

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strings"

	"github.com/Checkmarx/kics/internal/correlation"
	"github.com/Checkmarx/kics/internal/logger"
	"github.com/Checkmarx/kics/pkg/kics"
	"github.com/gorilla/mux"

	"github.com/rs/zerolog/log"
)

type Server struct {
	Port    string
	Service *kics.Service
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
	router.HandleFunc("/scan-summary", s.getScanSummary).Methods(http.MethodGet)

	return router
}

func (s *Server) getScanSummary(w http.ResponseWriter, r *http.Request) {
	corrID := correlation.FromHTTPRequest(r)
	ctx := correlation.AddToContext(r.Context(), corrID)

	logger.GetLoggerWithFieldsFromContext(ctx).
		Trace().
		Msg("rest api. getting scans summary")

	scanIDsString := r.URL.Query().Get("scan-ids")
	if strings.TrimSpace(scanIDsString) == "" {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	scanIDs := strings.Split(scanIDsString, ",")

	summary, err := s.Service.GetScanSummary(ctx, scanIDs)
	if err != nil {
		logger.GetLoggerWithFieldsFromContext(ctx).
			Err(err).
			Str("scanIDs", scanIDsString).
			Msg("rest api. failed to get summary")

		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	responseJSON(ctx, w, summary)
}

func (s *Server) getResults(w http.ResponseWriter, r *http.Request) {
	corrID := correlation.FromHTTPRequest(r)
	ctx := correlation.AddToContext(r.Context(), corrID)

	scanID := mux.Vars(r)["scan-id"]

	logger.GetLoggerWithFieldsFromContext(ctx).
		Trace().
		Str("scanID", scanID).
		Msg("rest api. getting scan results")

	results, err := s.Service.GetVulnerabilities(ctx, scanID)
	if err != nil {
		logger.GetLoggerWithFieldsFromContext(ctx).
			Err(err).
			Str("scanID", scanID).
			Msg("rest api. failed to get results for scan")

		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	responseJSON(ctx, w, results)
}

func responseJSON(ctx context.Context, w http.ResponseWriter, body interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	if encodeErr := json.NewEncoder(w).Encode(body); encodeErr != nil {
		logger.GetLoggerWithFieldsFromContext(ctx).
			Err(encodeErr).
			Msg("rest api. failed marshall response body")
	}
}
