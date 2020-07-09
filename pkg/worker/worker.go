package worker

import (
	"context"
	"fmt"

	"github.com/checkmarxDev/ice/internal/correlation"
	"github.com/checkmarxDev/ice/internal/logger"
	"github.com/checkmarxDev/ice/pkg/sources"

	"net/url"

	"github.com/checkmarxDev/scans/pkg/api/scans"

	"google.golang.org/protobuf/proto"

	api "github.com/checkmarxDev/scans/pkg/api/workflow"
	"github.com/checkmarxDev/scans/pkg/workflow"

	"github.com/rs/zerolog/log"
)

type WorkStatus struct {
	ScanID   string
	State    WorkState
	Progress string
	Info     string
}

type WorkState int32

const (
	// RunState_Created    RunState = 0
	WorkStateQueued     WorkState = 1
	WorkStateStarted    WorkState = 2
	WorkStateInProgress WorkState = 3
	WorkStateCompleted  WorkState = 4
	WorkStateFailed     WorkState = 5
)

func (w WorkState) String() string {
	switch w {
	case WorkStateQueued:
		return "Queued"
	case WorkStateStarted:
		return "Started"
	case WorkStateCompleted:
		return "Completed"
	case WorkStateFailed:
		return "Failed"
	case WorkStateInProgress:
		return "InProgress"
	default:
		return fmt.Sprintf("%d", int(w))
	}
}

type Worker struct {
	SourceProvider *sources.SourceProvider
}

func NewWorker(sourceProvider sources.SourceProvider) *Worker {
	return &Worker{
		SourceProvider: &sourceProvider,
	}
}

// Listen on worker task messages
func (w *Worker) Listen(ctx context.Context, natsURL, subject, qGroup string, connectionRetry int) error {
	errChan := make(chan error, 1)
	worker, err := workflow.NewWorkerNatsConnection(natsURL, subject, connectionRetry, errChan)
	if err != nil {
		return fmt.Errorf("cant connect to scan queue : %w", err)
	}

	log.Info().
		Msgf("Start Listening. natsURL=%s subject=%s qGroup=%s connectionRetry=%d", sanitizeURL(natsURL), subject, qGroup, connectionRetry)

	worker.HandleFunc(qGroup, func(msg *api.WorkerMessage) {
		corrID := msg.CorrelationID
		logWithFields := logger.GetLoggerWithCorrelationID(corrID)
		logWithFields.Info().Msgf("New message received. action=%s", msg.Action)

		protoScan := scans.Scan{}
		if err = proto.Unmarshal(msg.Input.Value, &protoScan); err != nil {
			logWithFields.Error().
				Err(err).
				Msg("could not deserialize scan")
			return
		}
		switch msg.Action { // nolint:gocritic
		case "WORK":
			go w.handelWork(worker, &protoScan, corrID)

			// TODO implement case "CANCEL":
		}
	})

	done := make(chan struct{}, 1)
	go func() {
		if sErr := worker.ServeMessages(); sErr != nil {
			errChan <- sErr
		}
	}()

	// Graceful shutdown on cancellation
	go func() {
		select {
		case <-ctx.Done():
			log.Info().Msg("Shutting down worker..")
			worker.Close()
			errChan <- ctx.Err()
		case <-done:
			return
		}
	}()

	err = <-errChan
	return err
}

func (w *Worker) handelWork(worker *workflow.WorkerNatsConnection, scan *scans.Scan, correlationID string) {
	logWithFields := logger.GetLoggerWithCorrelationID(correlationID)

	logWithFields.Info().Msgf("Start work on scan %s", scan.ID)

	ctx := correlation.AddToContext(context.Background(), correlationID)
	chWorkStatus := make(chan WorkStatus)
	go NewFetchTask(scan.ID, *w.SourceProvider).Fetch(ctx, chWorkStatus)

	for fetchStatus := range chWorkStatus {
		status := fetchStatus
		updateStatus(status.ScanID, status.State, status.Progress, status.Info, worker, correlationID)
	}

	logWithFields.Info().Msgf("Work done on scan %s", scan.ID)
}

func updateStatus(scanID string, state WorkState, progress, info string, worker *workflow.WorkerNatsConnection, correlationID string) {
	logWithFields := logger.GetLoggerWithCorrelationID(correlationID)

	logWithFields.Debug().
		Msgf("Send update status. scanId=%s state=%s progress=%s info=%s", scanID, state, progress, info)

	status := api.TaskStatus{
		State:    api.TaskStatus_TaskState(state),
		Info:     info,
		Progress: progress,
	}
	if err := worker.UpdateStatus(scanID, &status); err != nil {
		logWithFields.Error().
			Err(err).
			Msgf("Failed to update status. scanId=%s state=%s", scanID, state)
	}
}

func sanitizeURL(rawurl string) string {
	u, err := url.Parse(rawurl)
	if err != nil {
		return rawurl
	}
	u.User = url.UserPassword("xxx", "xxx")
	return u.String()
}
