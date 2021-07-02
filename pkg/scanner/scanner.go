package scanner

import (
	"context"
	"fmt"
	"sync"

	"github.com/Checkmarx/kics/internal/metrics"
	"github.com/Checkmarx/kics/pkg/kics"
	integer "github.com/Checkmarx/kics/pkg/progress/integer"
)

type serviceSlice []*kics.Service

// StartScan will run concurrent scans by parser
func StartScan(ctx context.Context, scanID string, noProgress bool, services serviceSlice) error {
	defer metrics.Metric.Stop()
	metrics.Metric.Start("start_scan")
	var wg sync.WaitGroup
	wgDone := make(chan bool)
	errCh := make(chan error)
	currentQuery := make(chan int64, 1)
	var wgProg sync.WaitGroup
	total := services.GetQueriesLength()
	if total != 0 {
		startProgressBar(noProgress, total, &wgProg, currentQuery)
	}
	for _, service := range services {
		wg.Add(1)
		go service.StartScan(ctx, scanID, noProgress, errCh, &wg, currentQuery)
	}

	go func() {
		defer func() {
			close(currentQuery)
			close(wgDone)
			fmt.Println("\r")
		}()
		wg.Wait()
		wgProg.Wait()
	}()

	select {
	case <-wgDone:
		break
	case err := <-errCh:
		close(errCh)
		return err
	}
	return nil
}

func (s serviceSlice) GetQueriesLength() int {
	count := 0
	for _, service := range s {
		count += service.Inspector.LenQueriesByPlat(service.Parser.Platform)
	}
	return count
}

func startProgressBar(hideProgress bool, total int, wg *sync.WaitGroup, progressChannel chan int64) {
	wg.Add(1)
	progressBar := integer.NewProgressBar("Executing queries: ", int64(total),
		progressChannel, &integer.Pool{})
	if hideProgress {
		progressBar.Silent()
	}
	go progressBar.Start(wg)
}
