package main

import (
	"os"

	"github.com/Checkmarx/kics/internal/console"
	"github.com/getsentry/sentry-go"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func main() { // nolint:funlen,gocyclo
	zerolog.SetGlobalLevel(zerolog.InfoLevel)
	writer := zerolog.ConsoleWriter{Out: os.Stdout}
	log.Logger = log.Output(writer)

	err := sentry.Init(sentry.ClientOptions{})
	if err != nil {
		log.Err(err).Msg("failed to initialize sentry")
	}

	console.Execute()
}
