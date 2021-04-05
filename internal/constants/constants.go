package constants

import "math"

// Version - current KICS version
var Version = "dev"

// Fullname - KICS fullname
const Fullname = "Keeping Infrastructure as Code Secure"

// SCMCommit - Source control management commit identifier
const SCMCommit = "N/A"

// LogFile - logfile name
const DefaultLogFile = "info.log"

// DefaultConfigFilename - default configuration filename
const DefaultConfigFilename = "kics.config"

// MinimumPreviewLines - default minimum preview lines number
const MinimumPreviewLines = 1

// MaximumPreviewLines - default maximum preview lines number
const MaximumPreviewLines = 30

// DetectLineErrorCode - Exit Status code for failed to detect line
const DetectLineErrorCode = 110

// EngineErrorCode - Exit Status code for error in engine
const EngineErrorCode = 126

// SignalInterruptCode - Exit Status code for a signal interrupt
const SignalInterruptCode = 130

// MaxInteger - max possible integer in golang
const MaxInteger = math.MaxInt64
