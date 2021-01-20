package main

import (
	"github.com/Checkmarx/kics/internal/console"
	"github.com/getsentry/sentry-go"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func main() { // nolint:funlen,gocyclo
	err := sentry.Init(sentry.ClientOptions{})
	if err != nil {
		log.Err(err).Msg("failed to initialize sentry")
	}
	zerolog.SetGlobalLevel(zerolog.InfoLevel)

	console.Execute()
}
