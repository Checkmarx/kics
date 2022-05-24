package main

import (
	"os"

	"github.com/Checkmarx/kics/internal/console"
	"github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/internal/constants"
)

func main() {
	if err := console.Execute(); err != nil {
		if helpers.ShowError("errors") {
			os.Exit(constants.EngineErrorCode)
		}
	}
}
