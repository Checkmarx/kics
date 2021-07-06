package scanner

import (
	"context"
	"fmt"
	"sync"

	"github.com/Checkmarx/kics/internal/metrics"
	"github.com/Checkmarx/kics/pkg/kics"
	"github.com/Checkmarx/kics/pkg/progress"
)

type serviceSlice []*kics.Service

// StartScan will run concurrent scans by parser
func StartScan(ctx context.Context, scanID string, proBarBuilder progress.PbBuilder, services serviceSlice) error {
	defer metrics.Metric.Stop()
	metrics.Metric.Start("start_scan")
	var wg sync.WaitGroup
	wgDone := make(chan bool)
	errCh := make(chan error)
	currentQuery := make(chan int64, 1)
	var wgProg sync.WaitGroup
	total := services.GetQueriesLength()
	if total != 0 {
		startProgressBar(total, &wgProg, currentQuery, proBarBuilder)
	}
	for _, service := range services {
		wg.Add(1)
		go service.StartScan(ctx, scanID, errCh, &wg, currentQuery)
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

// GetQueriesLength returns the Total of queries for all Services
func (s serviceSlice) GetQueriesLength() int {
	count := 0
	for _, service := range s {
		count += service.Inspector.LenQueriesByPlat(service.Parser.Platform)
	}
	return count
}

func startProgressBar(total int, wg *sync.WaitGroup, progressChannel chan int64, proBarBuilder progress.PbBuilder) {
	wg.Add(1)
	progressBar := proBarBuilder.BuildCounter("Executing queries: ", total, wg, progressChannel)
	go progressBar.Start()
}
