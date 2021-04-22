package global

import (
	"github.com/Checkmarx/kics/internal/metrics"
)

var (
	// Metric is the global metrics object
	Metric = &metrics.Metrics{
		Disable: true,
	}
)
