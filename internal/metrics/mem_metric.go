package metrics

import (
	"github.com/pkg/profile"
)

type memMetric struct{}

// Start - start gathering metrics for Memory usage
func (c memMetric) Start(location, path string) metricProfile {
	profMem := profile.Start(profile.MemProfile, profile.Quiet, profile.NoShutdownHook, profile.ProfilePath(path))
	return profMem
}

// Stop - stop gathering metrics for Memory usage
func (c memMetric) Stop(profMem metricProfile) {
	profMem.Stop()
}
