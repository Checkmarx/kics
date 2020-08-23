package worker

import (
	"context"
	"fmt"
	"net/url"

	"github.com/checkmarxDev/ice/pkg/worker/handler"

	"github.com/checkmarxDev/ice/internal/logger"

	api "github.com/checkmarxDev/scans/pkg/api/workflow"
	"github.com/checkmarxDev/scans/pkg/workflow/worker"
	"github.com/rs/zerolog/log"
)

type Worker struct {
	workerName         string
	workTimeoutMinutes uint
	ZBWorker           worker.Worker
	workHandler        handler.WorkHandler
}

func NewWorker(workerName string,
	workTimeoutMinutes uint,
	workloadAddr,
	jobType string,
	workHandler handler.WorkHandler) (*Worker, error) {
	log.Info().
		Msgf("Create new workload, workloadAddr=%s, jobType=%s", sanitizeURL(workloadAddr), jobType)

	wo, err := worker.NewZBWorker(workloadAddr, jobType, workerName, int(workTimeoutMinutes))
	if err != nil {
		return nil, fmt.Errorf("cant connect to scan queue : %w", err)
	}

	return &Worker{
		workerName:         workerName,
		workTimeoutMinutes: workTimeoutMinutes,
		ZBWorker:           wo,
		workHandler:        workHandler,
	}, nil
}

// Listen on worker task messages
func (w *Worker) Listen(ctx context.Context) error {
	log.Info().Msgf("Start workload Listening")
	errChan := make(chan error, 1)
	go func() {
		if err := w.ZBWorker.Start(); err != nil {
			errChan <- err
		}
	}()

	w.ZBWorker.Handler(func(jobKey int64, msg *api.Message) {
		for message := range w.workHandler.Handler(msg) {
			logWithFields := logger.GetLoggerWithCorrelationID(msg.CorrelationId)

			if message.Err != nil {
				logWithFields.Error().Err(message.Err).Msgf("Work failed on job=%d", jobKey)
				if err := w.ZBWorker.FailJob(jobKey, message.ErrMsg); err != nil {
					logWithFields.Error().
						Err(err).
						Msgf("Failed to send update that job %d failed for ScanID %s", jobKey, message.ScanID)
				}
			}
			switch message.State {
			case handler.JobStatusCompleted:
				logWithFields.Info().
					Msgf("Work on job %d completed. ScanID=%s", jobKey, message.ScanID)
				if err := w.ZBWorker.CompleteJob(jobKey); err != nil {
					logWithFields.Error().
						Err(err).
						Msgf("Failed to send update that job %d completed for scan %s", jobKey, message.ScanID)
				}
			case handler.JobStatusFailed:
				logWithFields.Info().
					Msgf("Work on job %d failed. reason=%s, ScanID=%s", jobKey, message.ErrMsg, message.ScanID)
				if err := w.ZBWorker.FailJob(jobKey, message.ErrMsg); err != nil {
					logWithFields.Error().
						Err(err).
						Msgf("Failed to send update that job %d failed for scan %s", jobKey, message.ScanID)
				}
			default:
				logWithFields.Debug().
					Msgf("Send update on job %d. ScanID=%s, progress=%s, info=%s", jobKey, message.ScanID, message.Progress, message.Info)
				if err := w.ZBWorker.UpdateStatus(message.ScanID, message.Progress, message.Info); err != nil {
					logWithFields.Error().
						Err(err).
						Msgf("Failed to update status for scan %s. jobKey=%d, progress=%s, info=%s",
							message.ScanID,
							jobKey,
							message.Progress,
							message.Info)
				}
			}
		}
	})

	// Graceful shutdown on cancellation
	go func() {
		select {
		case errFromChan := <-errChan:
			errChan <- errFromChan
		case <-ctx.Done():
			log.Info().Msg("Shutting down worker..")
			if err := w.ZBWorker.Close(); err != nil {
				log.Error().Err(err).Msg("Failed to close worker")
			}
			errChan <- ctx.Err()
		}
	}()

	err := <-errChan
	return err
}

func sanitizeURL(rawurl string) string {
	u, err := url.Parse(rawurl)
	if err != nil {
		return rawurl
	}
	u.User = url.UserPassword("xxx", "xxx")
	return u.String()
}
