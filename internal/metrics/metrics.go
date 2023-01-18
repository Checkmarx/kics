package metrics

import (
	"bytes"
	"fmt"
	"math"
	"strings"

	"github.com/google/pprof/profile"
	"github.com/rs/zerolog/log"
)

var (
	// Metric is the global metrics object
	Metric = &Metrics{
		Disable: true,
	}
)

// Start - starts gathering metrics based on the type of metrics and writes metrics to string
// Stop - stops gathering metrics for the type of metrics specified
type metricType interface {
	start()
	stop()
	getWriter() *bytes.Buffer
	getIndex() int
	getMap() map[string]float64
	getDefault() string
}

// Metrics - structure to keep information relevant to the metrics calculation
// Disable - disables metric calculations
type Metrics struct {
	metric    metricType
	metricsID string
	location  string
	Disable   bool
	total     int64
	ci        bool
}

// InitializeMetrics - creates a new instance of a Metrics based on the type of metrics specified
func InitializeMetrics(metric string, ci bool) error {
	var err error
	switch strings.ToLower(metric) {
	case "cpu":
		Metric.Disable = false
		Metric.metric = &cpuMetric{}
		Metric.total = 0
	case "mem":
		Metric.total = 0
		Metric.metric = &memMetric{}
		Metric.Disable = false
	case "":
		Metric.total = 0
		Metric.Disable = true
	default:
		Metric.total = 0
		Metric.Disable = true
		err = fmt.Errorf("unknown metric: %s (available metrics: CPU, MEM)", metric)
	}

	// Create temporary dir to keep pprof file
	if !Metric.Disable {
		Metric.metricsID = metric
		Metric.ci = ci
	}

	return err
}

// Start - starts gathering metrics for the location specified
func (m *Metrics) Start(location string) {
	if m.Disable {
		return
	}

	log.Debug().Msgf("Started %s profiling for %s", m.metricsID, location)

	m.location = location
	m.metric.start()
}

// Stop - stops gathering metrics and logs the result
func (m *Metrics) Stop() {
	if m.Disable {
		return
	}
	log.Debug().Msgf("Stopped %s profiling for %s", m.metricsID, m.location)

	m.metric.stop()

	p, err := profile.Parse(m.metric.getWriter())
	if err != nil {
		log.Error().Msgf("failed to parse profile on %s: %s", m.location, err)
	}

	if err := p.CheckValid(); err != nil {
		log.Error().Msgf("invalid profile on %s: %s", m.location, err)
	}

	total := getTotal(p, m.metric.getIndex())
	log.Info().
		Msgf("Total %s usage for %s: %s", strings.ToUpper(m.metricsID),
			m.location, m.formatTotal(total, m.metric.getMap(), m.metric.getDefault()))
	m.total = total
}

// getTotal goes through the profile samples summing their values according to
// the type of profile
func getTotal(prof *profile.Profile, idx int) int64 {
	var total, diffTotal int64
	for _, sample := range prof.Sample {
		var v int64
		v = sample.Value[idx]
		if v < 0 {
			v = -v
		}
		total += v
		if sample.DiffBaseSample() {
			diffTotal += v
		}
	}
	if diffTotal > 0 {
		total = diffTotal
	}

	return total
}

// formatTotal parses total value into a human readable way
func (m *Metrics) formatTotal(b int64, typeMap map[string]float64, defaultMetric string) string {
	value := float64(b)
	var formatter float64
	var mesure string
	if m.ci {
		metric := value / typeMap[defaultMetric]
		if math.IsNaN(metric) {
			metric = 0
		}
		return fmt.Sprintf("%.f%s", metric, defaultMetric)
	}
	for k, u := range typeMap {
		if u >= formatter && (value/u) >= 1.0 {
			formatter = u
			mesure = k
		}
	}

	metric := value / formatter
	if math.IsNaN(metric) {
		metric = 0
	}

	return fmt.Sprintf("%.2f%s", metric, mesure)
}
