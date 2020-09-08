package main

import (
	"context"
	"os"
	"os/signal"
	"sync"
	"syscall"

	"github.com/checkmarxDev/ice/internal/logger"
	"github.com/checkmarxDev/ice/internal/rest"
	"github.com/checkmarxDev/ice/internal/storage/postgresql"
	"github.com/checkmarxDev/ice/pkg/engine"
	"github.com/checkmarxDev/ice/pkg/engine/query"
	"github.com/checkmarxDev/ice/pkg/ice"
	"github.com/checkmarxDev/ice/pkg/parser"
	"github.com/checkmarxDev/ice/pkg/source"
	"github.com/checkmarxDev/ice/pkg/worker"
	"github.com/checkmarxDev/ice/pkg/worker/handler"
	_ "github.com/lib/pq"
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

	store, err := postgresql.NewPostgresStore(cfg.dbConnectionAddress)
	if err != nil {
		log.Fatal().Msg("Database initialization failed")
	}

	filesSource, err := source.NewRepostoreSourceProvider(ctx, cfg.repostoreRestAddress, cfg.repostoreGrpcAddress)
	if err != nil {
		log.Fatal().Msg("Repostore initialization failed")
	}

	querySource := &query.FilesystemSource{
		Source: cfg.querySourcePath,
	}

	inspector, err := engine.NewInspector(ctx, querySource, store)
	if err != nil {
		log.Fatal().Msg("Inspector initialization failed")
	}

	service := &ice.Service{
		SourceProvider: filesSource,
		Storage:        store,
		Parser:         parser.NewDefault(),
		Inspector:      inspector,
	}

	var servicesWg sync.WaitGroup
	initWorker(ctx, cfg, &servicesWg, errChan, service)
	initRESTServer(ctx, cfg, &servicesWg, errChan, service)

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

func initRESTServer(ctx context.Context, cfg *config, wg *sync.WaitGroup, errChan chan error, service *ice.Service) {
	if cfg.restPort == "" {
		log.Info().Msgf("%s is not provided, will not expose REST", iceRESTPortEnvField)
		return
	}

	wg.Add(1) //nolint:gomnd
	restServer := rest.Server{
		Port:    cfg.restPort,
		Service: service,
	}
	go func() {
		defer wg.Done()
		errChan <- restServer.ListenAndServe(ctx)
	}()
}

func initWorker(ctx context.Context, cfg *config, wg *sync.WaitGroup, errChan chan error, service *ice.Service) {
	// TODO service have a reason to live without work from queue ? if not we should fail the service.
	if cfg.workflowBrokerAddress == "" {
		log.Info().Msgf("%s is not provided, will not take work from message queue", workflowBrokerAddressEnvField)
		return
	}

	wg.Add(1) //nolint:gomnd
	scanHandler := &handler.ScanHandler{Scanner: service}
	workerInstance, err := worker.NewWorker(appName, cfg.workTimeoutMinutes, cfg.workflowBrokerAddress, cfg.workJobType, scanHandler)
	if err != nil {
		errChan <- err
	}
	go func() {
		defer wg.Done()
		errChan <- workerInstance.Listen(ctx)
	}()
}
