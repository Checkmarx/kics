package metrics

import (
	"github.com/pkg/profile"
)

type cpuMetric struct{}

// Start - start gathering metrics for CPU usage
func (c cpuMetric) Start(location, path string) metricProfile {
	profCPU := profile.Start(profile.CPUProfile, profile.Quiet, profile.NoShutdownHook, profile.ProfilePath(path))
	return profCPU
}

// Stop - stop gathering metrics for CPU usage
func (c cpuMetric) Stop(profCPU metricProfile) {
	profCPU.Stop()
}
