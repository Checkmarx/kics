package metrics

import (
	"bytes"
	"runtime/pprof"
	"time"

	"github.com/rs/zerolog/log"
)

type cpuMetric struct {
	close   func()
	writer  *bytes.Buffer
	idx     int
	typeMap map[string]float64
}

var cpuMap = map[string]float64{
	"ns":  float64(time.Nanosecond),
	"us":  float64(time.Microsecond),
	"ms":  float64(time.Millisecond),
	"s":   float64(time.Second),
	"hrs": float64(time.Hour),
}

func (c *cpuMetric) getDefault() string {
	return "ms"
}

// Start - start gathering metrics for CPU usage
func (c *cpuMetric) start() {
	c.idx = 1
	c.typeMap = cpuMap

	c.writer = bytes.NewBuffer([]byte{})

	if err := pprof.StartCPUProfile(c.writer); err != nil {
		log.Error().Msgf("failed to write cpu profile")
	}
	c.close = func() {
		pprof.StopCPUProfile()
	}
}

// Stop - stop gathering metrics for CPU usage
func (c *cpuMetric) stop() {
	c.close()
}

// getWriter returns the profile buffer
func (c *cpuMetric) getWriter() *bytes.Buffer {
	return c.writer
}

// getIndex returns the cpu sample index
func (c *cpuMetric) getIndex() int {
	return c.idx
}

// getMap returns the map used to format total value
func (c *cpuMetric) getMap() map[string]float64 {
	return c.typeMap
}
