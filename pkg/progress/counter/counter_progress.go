/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package counter

import (
	"io"
	"sync"

	"github.com/cheggaaa/pb/v3"
	"github.com/rs/zerolog/log"
)

// ProgressBar is a struct that holds the required fields for
// a Counter Progress Bar
type ProgressBar struct {
	label           string
	total           int64
	currentProgress int64
	progress        chan int64
	pBar            *pb.ProgressBar
	close           func() error
	wg              *sync.WaitGroup
}

const (
	barWidth = 80
)

// NewProgressBar creates a new instance of a Counter Progress Bar
func NewProgressBar(label string, total int64, progress chan int64, wg *sync.WaitGroup, silent bool) ProgressBar {
	newPb := pb.New64(total)
	newPb.SetMaxWidth(barWidth)
	newPb.Set("prefix", label)
	newPb.SetTemplateString(`{{string . "prefix"}}{{bar . }} {{percent . }}`)
	if silent {
		newPb.SetWriter(io.Discard)
	}
	newPb.Start()

	return ProgressBar{
		label:    label,
		total:    total,
		progress: progress,
		pBar:     newPb,
		wg:       wg,
		close: func() error {
			newPb.Finish()
			return nil
		},
	}
}

// Start initializes the Counter Progress Bar
func (p ProgressBar) Start() {
	defer func() {
		err := p.Close()
		if err != nil {
			log.Error().Msgf("failed to stop progress bar %v", err)
		}
		p.wg.Done()
	}()

	for {
		newProgress, ok := <-p.progress
		p.currentProgress += newProgress
		p.pBar.Increment()
		if !ok || p.currentProgress >= p.pBar.Total() {
			break
		}
	}
}

// Close stops the Counter Progress Bar
func (p ProgressBar) Close() error { return p.close() }
