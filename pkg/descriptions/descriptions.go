package descriptions

var (
	metricsClient HTTPDescription = &Client{}
)

// MetricsRequest - Request to update metrics
func MetricsRequest() error {

	if err := metricsClient.CheckConnection(); err != nil {
		return err
	}

	_, err := metricsClient.RequestUpdateMetrics()
	if err != nil {
		return err
	}

	return nil
}
