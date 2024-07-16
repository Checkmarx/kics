package printer

import (
	"time"

	consoleFlags "github.com/Checkmarx/kics/v2/internal/console/flags"
	"github.com/rs/zerolog"
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
func PrintScanDuration(logger *zerolog.Logger, elapsed time.Duration) {
	if consoleFlags.GetBoolFlag(consoleFlags.CIFlag) {
		elapsedStrFormat := "Scan duration: %vms\n"
		(*logger).Info().Msgf(elapsedStrFormat, elapsed.Milliseconds())
	} else {
		elapsedStrFormat := "Scan duration: %v\n"
		(*logger).Info().Msgf(elapsedStrFormat, elapsed)
	}
}
