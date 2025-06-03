package helpers

import (
	"fmt"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
)

var shouldIgnore string
var shouldFail map[string]struct{}

// ResultsExitCode calculate exit code base on severity of results, returns 0 if no results was reported
func ResultsExitCode(summary *model.Summary) int {
	// severityArr is needed to make sure 'for' cycle is made in an ordered fashion
	severityArr := []model.Severity{"CRITICAL", "HIGH", "MEDIUM", "LOW", "INFO", "TRACE"}
	codeMap := map[model.Severity]int{"CRITICAL": 60, "HIGH": 50, "MEDIUM": 40, "LOW": 30, "INFO": 20, "TRACE": 0}
	exitMap := summary.SeverityCounters
	for _, severity := range severityArr {
		if _, reportSeverity := shouldFail[strings.ToLower(string(severity))]; !reportSeverity {
			continue
		}
		if exitMap[severity] > 0 {
			return codeMap[severity]
		}
	}
	return 0
}

// InitShouldIgnoreArg initializes what kind of errors should be used on exit codes
func InitShouldIgnoreArg(arg string) error {
	validArgs := []string{"none", "all", "results", "errors"}
	for _, validArg := range validArgs {
		if strings.EqualFold(validArg, arg) {
			shouldIgnore = strings.ToLower(arg)
			return nil
		}
	}
	return fmt.Errorf("unknown argument for --ignore-on-exit: %s\nvalid arguments:\n  %s", arg, strings.Join(validArgs, "\n  "))
}

// InitShouldFailArg initializes which kind of vulnerability severity should changes exit code
func InitShouldFailArg(args []string) error {
	possibleArgs := map[string]struct{}{
		"critical": {},
		"high":     {},
		"medium":   {},
		"low":      {},
		"info":     {},
	}
	if len(args) == 0 {
		shouldFail = possibleArgs
		return nil
	}

	argsConverted := make(map[string]struct{})
	for _, arg := range args {
		if _, ok := possibleArgs[strings.ToLower(arg)]; !ok {
			validArgs := []string{"critical", "high", "medium", "low", "info"}
			return fmt.Errorf("unknown argument for --fail-on: %s\nvalid arguments:\n  %s", arg, strings.Join(validArgs, "\n  "))
		}
		argsConverted[strings.ToLower(arg)] = struct{}{}
	}

	shouldFail = argsConverted
	return nil
}

// ShowError returns true if should show error, otherwise returns false
func ShowError(kind string) bool {
	return strings.EqualFold(shouldIgnore, "none") || (!strings.EqualFold(shouldIgnore, "all") && !strings.EqualFold(shouldIgnore, kind))
}

// RemediateExitCode calculate exit code base on the difference between remediation selected and done
func RemediateExitCode(selectedRemediationNumber, actualRemediationDoneNumber int) int {
	statusCode := 70
	if selectedRemediationNumber != actualRemediationDoneNumber {
		// KICS AR was not able to remediate all the selected remediation
		return statusCode
	}

	return 0
}
