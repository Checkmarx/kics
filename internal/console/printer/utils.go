package printer

import (
	"fmt"
	"time"

	consoleFlags "github.com/Checkmarx/kics/internal/console/flags"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

func validateFlags() error {
	if consoleFlags.GetBoolFlag(consoleFlags.VerboseFlag) && consoleFlags.GetBoolFlag(consoleFlags.SilentFlag) {
		return errors.New("can't provide 'silent' and 'verbose' flags simultaneously")
	}

	if consoleFlags.GetBoolFlag(consoleFlags.VerboseFlag) && consoleFlags.GetBoolFlag(consoleFlags.CIFlag) {
		return errors.New("can't provide 'verbose' and 'ci' flags simultaneously")
	}

	if consoleFlags.GetBoolFlag(consoleFlags.CIFlag) && consoleFlags.GetBoolFlag(consoleFlags.SilentFlag) {
		return errors.New("can't provide 'silent' and 'ci' flags simultaneously")
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
