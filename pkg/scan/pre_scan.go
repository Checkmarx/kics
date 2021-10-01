package scan

import (
	"fmt"
	"os"
	"strings"
	"time"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/pkg/progress"
	"github.com/rs/zerolog/log"
	"golang.org/x/term"
)

// preScan is responsible for scan preparation
func preScan(banner string) (*consoleHelpers.Printer, *progress.PbBuilder, progress.PBar, time.Time) {
	printer := consoleHelpers.NewPrinter(ScanParams.MinimalUIFlag)
	printer.Success.Printf("\n%s\n", banner)

	versionMsg := fmt.Sprintf("\nScanning with %s\n\n", constants.GetVersion())
	fmt.Println(versionMsg)
	log.Info().Msgf(strings.ReplaceAll(versionMsg, "\n", ""))

	noProgress := ScanParams.NoProgressFlag
	if !term.IsTerminal(int(os.Stdin.Fd())) || strings.EqualFold(ScanParams.LogLevelFlag, "debug") {
		noProgress = true
	}

	proBarBuilder := progress.InitializePbBuilder(
		noProgress,
		ScanParams.CIFlag,
		ScanParams.SilentFlag)

	scanStartTime := time.Now()
	progressBar := proBarBuilder.BuildCircle("Preparing Scan Assets: ")
	progressBar.Start()

	return printer, proBarBuilder, progressBar, scanStartTime
}
