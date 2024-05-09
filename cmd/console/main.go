package main

import (
	"os"

	"github.com/Checkmarx/kics/v2/internal/console"
	"github.com/Checkmarx/kics/v2/internal/console/helpers"
	"github.com/Checkmarx/kics/v2/internal/constants"
)

func main() {
	if err := console.Execute(); err != nil {
		if helpers.ShowError("errors") {
			os.Exit(constants.EngineErrorCode)
		}
	}
}
