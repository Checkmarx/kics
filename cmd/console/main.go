package main

import (
	"os"

	"github.com/Checkmarx/kics/internal/console"
)

func main() { // nolint:funlen,gocyclo
	if err := console.Execute(); err != nil {
		os.Exit(1)
	}
}
