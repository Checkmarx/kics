package constants

const (
	//NoErrors - Exit Status code for no errors found
	NoErrors = 0

	// EngineErrorCode - Exit Status code for error in engine
	EngineErrorCode = 126

	// SignalInterruptCode - Exit Status code for a signal interrupt
	SignalInterruptCode = 130

	//NoFilesScannedExitCode - Exit Status code for a scan without files
	NoFilesScannedExitCode = 60

	//HighResultsExitCode - Exit Status code for a scan with High results
	HighResultsExitCode = 50

	//MediumResultsExitCode - Exit Status code for a scan with Medium results
	MediumResultsExitCode = 40

	//LowResultsExitCode - Exit Status code for a scan with Low results
	LowResultsExitCode = 30

	//InfoResultsExitCode - Exit Status code for a scan with Info results
	InfoResultsExitCode = 20

	//TraceResultsExitCode - Exit Status code for a scan with Trace results
	TraceResultsExitCode = 0

	//RemediationFailedExitCode - Exit Status code for calculate exit code base on the difference between remediation selected and done
	RemediationFailedExitCode = 70
)
