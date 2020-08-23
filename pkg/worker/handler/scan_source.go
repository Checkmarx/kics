package handler

import (
	"github.com/checkmarxDev/ice/internal/logger"
	"github.com/checkmarxDev/scans/pkg/api/scans"
	"github.com/checkmarxDev/scans/pkg/api/workflow"
	"google.golang.org/protobuf/proto"
)

type ScanHandler struct {
}

func (s *ScanHandler) Handler(msg *workflow.Message) <-chan StatusInfo {
	statusInfoCh := make(chan StatusInfo)

	corrID := msg.CorrelationId
	protoScan := scans.Scan{}
	if err := proto.Unmarshal(msg.Input.Value, &protoScan); err != nil {
		defer close(statusInfoCh)
		statusInfoCh <- StatusInfo{
			Err: err,
		}
		return statusInfoCh
	}

	go func(workStatChan chan StatusInfo) {
		defer close(workStatChan)
		s.handelWork(&protoScan, corrID, workStatChan)
	}(statusInfoCh)
	return statusInfoCh
}

func (s *ScanHandler) handelWork(scan *scans.Scan, correlationID string, statusInfo chan StatusInfo) {
	logWithFields := logger.GetLoggerWithCorrelationID(correlationID)

	scanID := scan.Id
	logWithFields.Info().Msgf("Start work on scan=%s", scanID)

	statusInfo <- StatusInfo{
		ScanID: scanID,
		State:  JobStatusCompleted,
	}

	logWithFields.Debug().Msgf("Work done on scan: %s", scanID)
}
