package scanner

import (
	"context"
	"fmt"
	"io"
	"sync"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/pkg/kics"
	"github.com/rs/zerolog/log"
)

type serviceSlice []*kics.Service

func StartScan(ctx context.Context, scanID string, noProgress bool, services serviceSlice) error {
	var wg sync.WaitGroup
	wgDone := make(chan bool)
	errCh := make(chan error)
	currentQuery := make(chan float64, 1)
	var wgProg sync.WaitGroup

	startProgressBar(noProgress, services.GetQueriesLength(), &wgProg, currentQuery)
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
		log.Error().Msg("Waiting finished")
		break
	case err := <-errCh:
		close(errCh)
		log.Error().Msgf("Received Error %s", err)
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

func startProgressBar(hideProgress bool, total int, wg *sync.WaitGroup, progressChannel chan float64) {
	wg.Add(1)
	progressBar := consoleHelpers.NewProgressBar("Executing queries: ", 10, float64(total), progressChannel)
	if hideProgress {
		progressBar.Writer = io.Discard
	}
	go progressBar.Start(wg)
}
