package integer

import (
	"sync"

	"github.com/cheggaaa/pb"
	"github.com/rs/zerolog/log"
)

const (
	barWidth = 80
)

// ProgressBar represents a Progress
// Writer is the writer output for progress bar
type ProgressBar struct {
	label           string
	total           int64
	currentProgress int64
	progress        chan int64
	pBar            *pb.ProgressBar
	pPool           *Pool
	close           func() error
}

type Pool struct {
	pool *pb.Pool
	pbs  int
	lock sync.Mutex
}

// NewProgressBar initializes a new ProgressBar
// label is a string print before the progress bar
// total is the progress bar target (a.k.a 100%)
// space is the number of '=' characters on each side of the bar
// progress is a channel updating the current executed elements
func NewProgressBar(label string, total int64, progress chan int64, progressPool *Pool) ProgressBar {
	newPb := pb.New64(total)
	newPb.SetWidth(barWidth)
	newPb.Prefix(label)

	if progressPool.pool == nil {
		progressPool.pool = pb.NewPool()
		if err := progressPool.pool.Start(); err != nil {
			log.Error().Msgf("got an error %v", err)
		}
	}

	progressPool.pool.Add(newPb)
	progressPool.pbs++

	return ProgressBar{
		label:    label,
		total:    total,
		progress: progress,
		pBar:     newPb,
		pPool:    progressPool,
		close: func() error {
			progressPool.lock.Lock()
			defer progressPool.lock.Unlock()
			newPb.Finish()
			progressPool.pbs--
			if progressPool.pbs <= 0 {
				if err := progressPool.pool.Stop(); err != nil {
					log.Error().Msgf("got an error %v", err)
				}
				progressPool.pool = nil
			}
			return nil
		},
	}
}

// Start starts to print a progress bar on console
// wg is a wait group to report when progress is done
func (p *ProgressBar) Start(wg *sync.WaitGroup) {
	defer func() {
		p.Close()
		wg.Done()
	}()

	for {
		newProgress, ok := <-p.progress
		p.currentProgress += newProgress
		p.pBar.Set64(p.currentProgress)
		if !ok || p.currentProgress >= p.pBar.Total {
			break
		}
	}
}

func (p *ProgressBar) Close() error { return p.close() }
