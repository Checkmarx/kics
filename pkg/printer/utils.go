package printer

import (
	"time"

	"github.com/rs/zerolog"
)

// PrintScanDuration prints the scan duration
func PrintScanDuration(logger *zerolog.Logger, elapsed time.Duration) {
	elapsedStrFormat := "Scan duration: %v\n"
	(*logger).Info().Msgf(elapsedStrFormat, elapsed)
}
