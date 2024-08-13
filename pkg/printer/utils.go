/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
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
