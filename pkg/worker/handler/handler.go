package handler

import (
	"fmt"

	"github.com/checkmarxDev/scans/pkg/api/workflow"
)

type FetchStatus struct {
	ScanID   string
	State    WorkState
	Progress string
	Info     string
}

type WorkState int32

const (
	JobStatusQueued    WorkState = 0
	JobStatusRunning   WorkState = 1
	JobStatusCompleted WorkState = 2
	JobStatusFailed    WorkState = 3
	JobStatusCanceled  WorkState = 4
)

func (w WorkState) String() string {
	switch w {
	case JobStatusQueued:
		return "Queued"
	case JobStatusRunning:
		return "Running"
	case JobStatusCompleted:
		return "Completed"
	case JobStatusFailed:
		return "Failed"
	case JobStatusCanceled:
		return "Canceled"
	default:
		return fmt.Sprintf("%d", int(w))
	}
}

type StatusInfo struct {
	ScanID, Progress, Info string
	State                  WorkState
	Err                    error
	ErrMsg                 string
}

type WorkHandler interface {
	Handler(msg *workflow.Message) <-chan StatusInfo
}
