package main

import (
	"context"
	"github.com/checkmarxDev/ice/pkg/worker/handler"
	"os"
	"os/signal"
	"sync"
	"syscall"

	"github.com/checkmarxDev/ice/internal/logger"
	"github.com/checkmarxDev/ice/internal/rest"
	"github.com/checkmarxDev/ice/pkg/worker"
	"github.com/rs/zerolog/log"
)

const (
	appName = "ice"
)

func main() {
	log.Info().Str(logger.AppNameFieldName, appName).Msg("Service started.")

	cfg := loadConfig()

	if err := logger.InitLogger(cfg.logLevel, appName); err != nil {
		log.Fatal().
			Err(err).
			Msgf("Failed initialize logger to: %s.", cfg.logLevel)
	}

	ctx := context.Background()
	ctx, cancel := context.WithCancel(ctx)
	errChan := make(chan error)

	var servicesWg sync.WaitGroup
	initWorker(ctx, cfg, &servicesWg, errChan)
	initRESTServer(ctx, cfg, &servicesWg, errChan)

	go func() {
		servicesWg.Wait()
		close(errChan)
	}()

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, syscall.SIGHUP, syscall.SIGINT, syscall.SIGQUIT, syscall.SIGTERM)
	select {
	case err := <-errChan:
		if err != nil {
			log.Fatal().Err(err).Msg("Server error occurred.")
		}
	case sig := <-c:
		log.Warn().Msgf("Caught sig: %+v, Server interrupted...", sig)
		cancel()
		// make sure all services shutdown with no errors
		for interruptedErr := range errChan {
			if interruptedErr != context.Canceled {
				log.Fatal().Err(<-errChan).Msg("Error during graceful close.")
			}
		}
	}

	log.Info().Msg("service Ended")
}

func initRESTServer(ctx context.Context, cfg *config, wg *sync.WaitGroup, errChan chan error) {
	if cfg.restPort == "" {
		log.Info().Msgf("%s is not provided, will not expose REST", IceRESTPortEnvField)
		return
	}

	wg.Add(1) //nolint:gomnd
	restServer := rest.NewRestServer(cfg.restPort)
	go func() {
		defer wg.Done()
		errChan <- restServer.ListenAndServe(ctx)
	}()
}

func initWorker(ctx context.Context, cfg *config, wg *sync.WaitGroup, errChan chan error) {
	// TODO service have a reason to live without work from queue ? if not we should fail the service.
	if cfg.WorkflowBrokerAddress == "" {
		log.Info().Msgf("%s is not provided, will not take work from message queue", WorkflowBrokerAddressEnvField)
		return
	}

	wg.Add(1) //nolint:gomnd
	scanHandler := &handler.ScanHandler{}
	workerInstance, err := worker.NewWorker(appName, cfg.workTimeoutMinutes, cfg.WorkflowBrokerAddress, cfg.workJobType, scanHandler)
	if err != nil {
		errChan <- err
	}
	go func() {
		defer wg.Done()
		errChan <- workerInstance.Listen(ctx)
	}()
}
