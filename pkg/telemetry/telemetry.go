package telemetry

import "github.com/Checkmarx/kics/pkg/model"

var (
	telemetryClient HTTPTelemetry = &Client{}
)

// TelemetryRequest - Request to update telemetry
func TelemetryRequest(summary *model.Summary) error {
	descriptionIDs := make([]string, 0)
	for idx := range summary.Queries {
		descriptionIDs = append(descriptionIDs, summary.Queries[idx].DescriptionID)
	}

	if err := telemetryClient.CheckConnection(); err != nil {
		return err
	}

	_, err := telemetryClient.RequestUpdateTelemetry(descriptionIDs)
	if err != nil {
		return err
	}

	return nil
}
