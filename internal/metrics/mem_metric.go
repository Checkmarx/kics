package metrics

import (
	"bytes"
	"runtime"
	"runtime/pprof"

	"github.com/rs/zerolog/log"
)

type memMetric struct {
	close   func()
	writer  *bytes.Buffer
	idx     int
	typeMap map[string]float64
}

var (
	b  = 1
	kb = 10
	mb = 20
	gb = 30
	tb = 40
	pb = 50
)

var memoryMap = map[string]float64{
	"B":  float64(b),
	"kB": float64(b << kb),
	"MB": float64(b << mb),
	"GB": float64(b << gb),
	"TB": float64(b << tb),
	"PB": float64(b << pb),
}

// Start - start gathering metrics for Memory usage
func (c *memMetric) start() {
	c.idx = 3
	c.typeMap = memoryMap

	old := runtime.MemProfileRate
	runtime.MemProfileRate = 4096 // set default memory rate

	c.writer = bytes.NewBuffer([]byte{})
	c.close = func() {
		if err := pprof.Lookup("heap").WriteTo(c.writer, 0); err != nil {
			log.Error().Msgf("failed to write mem profile")
		}

		runtime.MemProfileRate = old
	}
}

func (c *memMetric) getDefault() string {
	return "B"
}

// Stop - stop gathering metrics for Memory usage
func (c *memMetric) stop() {
	c.close()
}

// getWriter returns the profile buffer
func (c *memMetric) getWriter() *bytes.Buffer {
	return c.writer
}

// getIndex returns the memory sample index
func (c *memMetric) getIndex() int {
	return c.idx
}

// getMap returns the map used to format total value
func (c *memMetric) getMap() map[string]float64 {
	return c.typeMap
}
