package printer

import (
	"fmt"
	"time"

	consoleFlags "github.com/Checkmarx/kics/internal/console/flags"
	"github.com/rs/zerolog/log"
)

func validateFlags() error {
	verboseFlag := consoleFlags.GetBoolFlag(consoleFlags.VerboseFlag)
	silentFlag := consoleFlags.GetBoolFlag(consoleFlags.SilentFlag)
	ciFlag := consoleFlags.GetBoolFlag(consoleFlags.CIFlag)

	if silentFlag && verboseFlag {
		return consoleFlags.FormatNewError(consoleFlags.SilentFlag, consoleFlags.VerboseFlag)
	}

	if verboseFlag && ciFlag {
		return consoleFlags.FormatNewError(consoleFlags.VerboseFlag, consoleFlags.CIFlag)
	}

	if silentFlag && ciFlag {
		return consoleFlags.FormatNewError(consoleFlags.SilentFlag, consoleFlags.CIFlag)
	}
	return nil
}

// PrintScanDuration prints the scan duration
func PrintScanDuration(elapsed time.Duration) {
	if consoleFlags.GetBoolFlag(consoleFlags.CIFlag) {
		elapsedStrFormat := "Scan duration: %vms\n"
		fmt.Printf(elapsedStrFormat, elapsed.Milliseconds())
		log.Info().Msgf(elapsedStrFormat, elapsed.Milliseconds())
	} else {
		elapsedStrFormat := "Scan duration: %v\n"
		fmt.Printf(elapsedStrFormat, elapsed)
		log.Info().Msgf(elapsedStrFormat, elapsed)
	}
}
