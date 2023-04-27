package metrics

import "github.com/Checkmarx/kics/pkg/model"

var (
	metricsClient HTTPDescription = &Client{}
)

// MetricsRequest - Request to update metrics
func MetricsRequest(summary *model.Summary) error {
	descriptionIDs := make([]string, 0)
	for idx := range summary.Queries {
		descriptionIDs = append(descriptionIDs, summary.Queries[idx].DescriptionID)
	}

	if err := metricsClient.CheckConnection(); err != nil {
		return err
	}

	_, err := metricsClient.RequestUpdateMetrics(descriptionIDs)
	if err != nil {
		return err
	}

	return nil
}
