package worker

import (
	//"github.com/checkmarxDev/ice/internal/logger"
	"context"
	"github.com/checkmarxDev/ice/internal/logger"
	"github.com/checkmarxDev/ice/pkg/sources"
	"io/ioutil"
	"os"
	"path/filepath"
)

type FetchWorker interface {
	Fetch(chFetchStatus chan WorkStatus) error
}

type WorkTask struct {
	ScanID         string
	sourceProvider sources.SourceProvider
}

func NewFetchTask(scanID string, sourceProvider *sources.SourceProvider) *WorkTask {
	return &WorkTask{
		ScanID:         scanID,
		sourceProvider: *sourceProvider,
	}
}

func (t *WorkTask) Fetch(ctx context.Context, chFetchStatus chan WorkStatus) {
	defer close(chFetchStatus)
	logWithFields := logger.GetLoggerWithFieldsFromContext(ctx)

	chFetchStatus <- WorkStatus{
		State:  WorkStateStarted,
		ScanID: t.ScanID,
	}
	sourcesPath, err := ioutil.TempDir("", "")
	if err != nil {
		chFetchStatus <- WorkStatus{
			State:  WorkStateFailed,
			ScanID: t.ScanID,
			Info:   "Failed to create temp folder for sources",
		}
	}
	defer os.RemoveAll(sourcesPath)

	if err := t.sourceProvider.DownloadSources(ctx, t.ScanID, sourcesPath); err != nil {
		chFetchStatus <- WorkStatus{
			State:  WorkStateFailed,
			ScanID: t.ScanID,
			Info:   err.Error(),
		}
		return
	}

	// TODO example print files downloaded
	_ = filepath.Walk(sourcesPath, func(path string, info os.FileInfo, err error) error {
		if !info.IsDir() {
			logWithFields.Info().Msg(info.Name())
		}
		return nil
	})

	chFetchStatus <- WorkStatus{
		State:  WorkStateCompleted,
		ScanID: t.ScanID,
	}

}
