package progress

import (
	"sync"

	"github.com/Checkmarx/kics/v2/pkg/progress/circle"
	"github.com/Checkmarx/kics/v2/pkg/progress/counter"
)

// PBar is the interface for the types of available progress bars (Circle ,Counter)
// Start initializes the Progress Bar execution
// Close stops the Progress Bar execution
type PBar interface {
	Start()
	Close() error
}

// PbBuilder is the struct that contains the progress bar Builders
// Silent is set to true when all progress bars should be silent
type PbBuilder struct {
	Silent bool
}

// InitializePbBuilder creates an instace of a PbBuilder
func InitializePbBuilder(noProgress, ci, silentFlag bool) *PbBuilder {
	pbbuilder := PbBuilder{
		Silent: false,
	}
	if noProgress || ci || silentFlag {
		pbbuilder = PbBuilder{
			Silent: true,
		}
	}
	return &pbbuilder
}

// BuildCounter builds and returns a Counter Progress Bar
func (i *PbBuilder) BuildCounter(label string, total int, wg *sync.WaitGroup, progressChannel chan int64) PBar {
	return counter.NewProgressBar(label, int64(total), progressChannel, wg, i.Silent)
}

// BuildCircle builds and returns a Circle Progress Bar
func (i *PbBuilder) BuildCircle(label string) PBar {
	return circle.NewProgressBar(label, i.Silent)
}
