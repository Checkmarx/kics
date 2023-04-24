package descriptions

var (
	descClient HTTPDescription = &Client{}
)

// RequestUpdateMetrics - Request to update metrics with new inputs
func RequestUpdateMetrics() error {
	if err := descClient.CheckConnection(); err != nil {
		return err
	}

	err := descClient.RequestUpdateMetrics()
	if err != nil {
		return err
	}

	return nil
}
