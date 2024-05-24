package circle

import (
	"fmt"
	"io"
	"time"

	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/cheggaaa/pb/v3"
)

const (
	barWidth     = 0
	sleepTimeout = 100
)

// ProgressBar is a struct that holds the required fields for
// a Circle Progress Bar
type ProgressBar struct {
	label string
	pBar  *pb.ProgressBar
	close func() error
}

// NewProgressBar creates a new instance of a Circle Progress Bar
func NewProgressBar(label string, silent bool) ProgressBar {
	newPb := pb.New64(constants.MaxInteger)
	tmp := fmt.Sprintf(`{{ %q }} {{(cycle . "\\" "-" "|" "/" "-" "|" )}}`, label)
	newPb.SetWidth(barWidth)
	newPb.SetTemplateString(tmp)
	if silent {
		newPb.SetWriter(io.Discard)
	}
	newPb.Start()

	return ProgressBar{
		label: label,
		pBar:  newPb,
		close: func() error {
			newPb.Finish()
			return nil
		},
	}
}

// Start initializes the Circle Progress Bar
func (p ProgressBar) Start() {
	for { // increment until the Close func is called
		p.pBar.Increment()
		// lower cpu usage from infinite loop
		time.Sleep(time.Millisecond * sleepTimeout)
	}
}

// Close stops the Circle Progress Bar and
// changes the template to done
func (p ProgressBar) Close() error {
	p.pBar.SetTemplateString(fmt.Sprintf("%sDone", p.label))
	return p.close()
}
