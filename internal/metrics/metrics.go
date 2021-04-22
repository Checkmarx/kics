package metrics

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/rs/zerolog/log"
	"github.com/spf13/pflag"
)

// Start - starts gathering metrics based on the type of metrics and writes metrics to string
// Stop - stops gathering metrics for the type of metrics specified
type metricType interface {
	Start(location, path string) metricProfile
	Stop(metricProfile)
}

type metricProfile interface{ Stop() }

// Metrics - structure to keep information relevant to the metrics calculation
type Metrics struct {
	metric    metricType
	metricsID string
	location  string
	profile   metricProfile
	disable   bool
	tempDIR   string
}

// InitializeMetrics - creates a new instance of a Metrics based on the type of metrics specified
func InitializeMetrics(metric *pflag.Flag) (*Metrics, error) {
	metricStr := metric.Value.String()
	var err error
	metrics := &Metrics{}
	switch strings.ToLower(metricStr) {
	case "cpu":
		metrics.metric = cpuMetric{}
	case "mem":
		metrics.metric = memMetric{}
	case "":
		metrics.disable = true
	default:
		metrics.disable = true
		err = fmt.Errorf("unknonwn metric: %s (available metrics: cpu, mem)", metricStr)
	}

	// Create temporary dir to keep pprof file
	if !metrics.disable {
		temp, errCreate := os.MkdirTemp(".", "*")
		if errCreate != nil {
			err = errCreate
		}

		metrics.tempDIR = temp
		metrics.metricsID = metricStr
	}

	return metrics, err
}

// Start - starts gathering metrics for the location specified
func (m *Metrics) Start(location string) {
	if m.disable {
		return
	}
	log.Debug().Msgf("Started %s profiling for %s", m.metricsID, location)
	m.location = location
	m.profile = m.metric.Start(location, m.tempDIR)
}

// Stop - stops gathering metrics and logs the result
func (m *Metrics) Stop() {
	if m.disable {
		return
	}
	profile := fmt.Sprintf("%s.pprof", strings.ToLower(m.metricsID))
	log.Debug().Msgf("Stopped %s profiling for %s", m.metricsID, m.location)
	m.metric.Stop(m.profile)

	if err := m.readFile(filepath.Join(m.tempDIR, profile)); err != nil {
		log.Error().Msgf("failed to get metrics from %s: %s", m.location, err)
	}
}

func (m *Metrics) readFile(profile string) error {
	// Remove temporary directory
	defer func() {
		if err := os.RemoveAll(m.tempDIR); err != nil {
			log.Error().Msgf("failed to remove metric temporary dir %s: %s", m.tempDIR, err)
		}
	}()
	// Since profiling in golang creates a binary pprof file we need to call pprof tool
	// to the information we need
	cmd := exec.Command("go", "tool", "pprof", "-list", "total", profile)
	b, err := cmd.Output()
	if err != nil {
		return err
	}

	// Get information of total metric usage
	lines := strings.Split(string(b), "\n")
	log.Info().Msgf("Total %s usage for %s: %s", strings.ToUpper(m.metricsID), m.location, lines[0])

	return nil
}
