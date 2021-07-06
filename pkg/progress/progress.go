package progress

import (
	"sync"

	"github.com/Checkmarx/kics/pkg/progress/circle"
	"github.com/Checkmarx/kics/pkg/progress/counter"
)

// PBar is the interface for the types of available progress bars (Circle ,Counter)
// Start initializes the Progress Bar execution
// Close stops the Progress Bar execution
type PBar interface {
	Start()
	Close() error
}

// PbBuilder is the struct that contains the progress bar Builders
type PbBuilder struct {
	silent bool
}

// InitializePbBuilder creates an instace of a PbBuilder
func InitializePbBuilder(noProgress, ci, silentFlag bool) *PbBuilder {
	pbbuilder := PbBuilder{
		silent: false,
	}
	if noProgress || ci || silentFlag {
		pbbuilder = PbBuilder{
			silent: true,
		}
	}
	return &pbbuilder
}

// BuildCounter builds and returns a Counter Progress Bar
func (i *PbBuilder) BuildCounter(label string, total int, wg *sync.WaitGroup, progressChannel chan int64) PBar {
	return counter.NewProgressBar(label, int64(total), progressChannel, wg, i.silent)
}

// BuildCircle builds and returns a Circle Progress Bar
func (i *PbBuilder) BuildCircle(label string) PBar {
	return circle.NewProgressBar(label, i.silent)
}
