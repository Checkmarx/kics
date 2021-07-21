package constants

import (
	"fmt"
	"math"
)

var (
	// Version - current KICS version
	Version = "development"
	// SCMCommit - Source control management commit identifier
	SCMCommit = "NOCOMMIT"
	// SentryDSN - sentry DSN, unset for disabling
	SentryDSN = ""
	// BaseURL - CIS descriptions endpoint URL
	BaseURL = ""
)

const (
	// Fullname - KICS fullname
	Fullname = "Keeping Infrastructure as Code Secure"

	// URL - KICS url
	URL = "https://www.kics.io/"

	// DefaultLogFile - logfile name
	DefaultLogFile = "info.log"

	// DefaultConfigFilename - default configuration filename
	DefaultConfigFilename = "kics.config"

	// MinimumPreviewLines - default minimum preview lines number
	MinimumPreviewLines = 1

	// MaximumPreviewLines - default maximum preview lines number
	MaximumPreviewLines = 30

	// EngineErrorCode - Exit Status code for error in engine
	EngineErrorCode = 126

	// SignalInterruptCode - Exit Status code for a signal interrupt
	SignalInterruptCode = 130

	// MaxInteger - max possible integer in golang
	MaxInteger = math.MaxInt64

	// SentryRefreshRate - sentry crash report refresh rate
	SentryRefreshRate = 2
)

// GetRelease - returns the current release in the format 'kics@version' to be used by sentry
func GetRelease() string {
	return fmt.Sprintf("kics@%s", Version)
}

// GetVersion - returns the current version in the format 'Keeping Infrastructure as Code Secure <version>'
func GetVersion() string {
	return fmt.Sprintf("%s %s", Fullname, Version)
}
