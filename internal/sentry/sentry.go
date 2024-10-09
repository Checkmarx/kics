package sentry

import (
	"encoding/json"

	"github.com/Checkmarx/kics/v2/internal/console/flags"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/getsentry/sentry-go"
	"github.com/rs/zerolog/log"
)

// Report is the struct containing necessary information to send to sentry
type Report struct {
	Location         string                 `json:"location"`
	Flags            map[string]interface{} `json:"flags"`
	FileName         string                 `json:"file_name"`
	Query            string                 `json:"query_name"`
	Platform         string                 `json:"platform"`
	Kind             model.FileKind         `json:"kind"`
	Metadata         map[string]interface{} `json:"query_metadata"`
	Message          string                 `json:"message"`
	Err              error                  `json:"error"`
	AdditionalValues map[string]interface{} `json:"additional_values"`
}

// ReportSentry creates a new issue with the necessary information to sentry
// and logs the issue
func ReportSentry(report *Report, shouldLog bool) {
	sentry.WithScope(func(scope *sentry.Scope) {
		report.Flags = flags.GetAllFlags()
		value := make(map[string]interface{})
		value["report"] = report
		scope.SetContext("Issue", value)
		sentry.CaptureException(report.Err)
	})

	if shouldLog {
		log.Err(report.Err).Msgf("%s", report.Message)
		log.Debug().Msgf("Error Report: \n%+v\n", report.string())
	}
}

func (r *Report) string() string {
	stringifyed, err := json.MarshalIndent(&r, "", "  ")
	if err != nil {
		log.Err(err).Msgf("Failed to marshall sentry report")
	}
	return string(stringifyed)
}
