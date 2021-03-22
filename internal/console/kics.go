package console

import (
	"context"
	"os"
	"time"

	"github.com/getsentry/sentry-go"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
)

var ctx = context.Background()

const (
	scanID   = "console"
	timeMult = 2
)

var rootCmd = &cobra.Command{
	Use:   "kics",
	Short: "Keeping Infrastructure as Code Secure",
}

func initialize() {
	log.Trace().Msg("initializing kics command")
	rootCmd.AddCommand(versionCmd)
	rootCmd.AddCommand(generateIDCmd)
	rootCmd.AddCommand(scanCmd)

	initScanCmd()
	if insertScanCmd() {
		log.Warn().Msg("DEPRECATION WARNING: adding 'scan' sub-command as argument" +
			"since it was not provided, in for future versions use 'kics scan'")
		os.Args = append([]string{os.Args[0], "scan"}, os.Args[1:]...)
	}
}

func insertScanCmd() bool {
	if len(os.Args) > 1 && os.Args[1][0] == '-' {
		if os.Args[1][1] != '-' {
			flag := os.Args[1][1:]
			return scanCmd.Flags().ShorthandLookup(flag) != nil
		}
		flag := os.Args[1][2:]
		return scanCmd.Flag(flag) != nil
	}
	return false
}

// Execute starts kics execution
func Execute() {
	defer sentry.Flush(timeMult * time.Second)
	initialize()

	log.Debug().Msg("executing kics command context")
	if err := rootCmd.ExecuteContext(ctx); err != nil {
		sentry.CaptureException(err)
		log.Err(err).Msg("failed to run application")
	}
}
