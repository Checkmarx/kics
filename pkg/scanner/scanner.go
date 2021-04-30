package scanner

import (
	"context"
	"sync"

	"github.com/Checkmarx/kics/pkg/kics"
	"github.com/rs/zerolog/log"
)

func StartScan(ctx context.Context, scanID string, noProgress bool, services []*kics.Service) error {
	var wg sync.WaitGroup
	wgDone := make(chan bool)
	errCh := make(chan error)

	for _, service := range services {
		wg.Add(1)
		go service.StartScan(ctx, scanID, noProgress, errCh, &wg)
	}

	go func() {
		defer func() {
			close(wgDone)
		}()
		wg.Wait()
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
