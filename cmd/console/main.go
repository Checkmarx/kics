package main

import (
	"os"

	"github.com/Checkmarx/kics/internal/console"
	"github.com/Checkmarx/kics/internal/constants"
)

func main() { // nolint:funlen,gocyclo
	if err := console.Execute(); err != nil {
		os.Exit(constants.EngineErrorCode)
	}
}
