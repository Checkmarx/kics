package constants

import (
	"fmt"
	"math"
	"os"
	"path/filepath"
)

var (
	// Version - current KICS version
	Version = "development"
	// SCMCommit - Source control management commit identifier
	SCMCommit = "NOCOMMIT"
	// SentryDSN - sentry DSN, unset for disabling
	SentryDSN = ""
	// BaseURL - Descriptions endpoint URL
	BaseURL = ""
	// APIScanner - API scanner feature switch
	APIScanner = ""

	// AvailableCategories - All categories and its identifies
	AvailableCategories = map[string]string{
		"Access Control":          "CAT001",
		"Availability":            "CAT002",
		"Backup":                  "CAT003",
		"Best Practices":          "CAT004",
		"Build Process":           "CAT005",
		"Encryption":              "CAT006",
		"Insecure Configurations": "CAT007",
		"Insecure Defaults":       "CAT008",
		"Networking and Firewall": "CAT009",
		"Observability":           "CAT010",
		"Resource Management":     "CAT011",
		"Secret Management":       "CAT012",
		"Supply-Chain":            "CAT013",
		"Structure and Semantics": "CAT014",
		"Bill Of Materials":       "CAT015",
	}

	// AvailablePlatforms - All platforms available
	AvailablePlatforms = map[string]string{
		"Ansible":                 "ansible",
		"CICD":                    "cicd",
		"CloudFormation":          "cloudFormation",
		"Crossplane":              "crossplane",
		"Dockerfile":              "dockerfile",
		"DockerCompose":           "dockerCompose",
		"Knative":                 "knative",
		"Kubernetes":              "k8s",
		"OpenAPI":                 "openAPI",
		"Terraform":               "terraform",
		"AzureResourceManager":    "azureResourceManager",
		"GoogleDeploymentManager": "googleDeploymentManager",
		"GRPC":                    "grpc",
		"Buildah":                 "buildah",
		"Pulumi":                  "pulumi",
		"ServerlessFW":            "serverlessFW",
	}

	// AvailableSeverities - All severities available
	AvailableSeverities = []string{
		"critical",
		"high",
		"medium",
		"low",
		"info",
		"trace",
	}

	// AvailableLogLevels - All log levels available
	AvailableLogLevels = []string{
		"TRACE",
		"DEBUG",
		"INFO",
		"WARN",
		"ERROR",
		"FATAL",
	}

	// AvailableCloudProviders - All cloud providers available
	AvailableCloudProviders = map[string]string{
		"alicloud":     "",
		"aws":          "",
		"azure":        "",
		"gcp":          "",
		"nifcloud":     "",
		"tencentcloud": "",
	}
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

	// LogFormatJSON - print log as json
	LogFormatJSON = "json"

	// LogFormatPretty - print log more readable
	LogFormatPretty = "pretty"

	Reference = "$ref"
)

// GetRelease - returns the current release in the format 'kics@version' to be used by sentry
func GetRelease() string {
	return fmt.Sprintf("kics@%s", Version)
}

// GetVersion - returns the current version in the format 'Keeping Infrastructure as Code Secure <version>'
func GetVersion() string {
	return fmt.Sprintf("%s %s", Fullname, Version)
}

// GetDefaultLogPath - returns the path where the default log file is located
func GetDefaultLogPath() (string, error) {
	currentWorkDir, err := os.Getwd()
	if err != nil {
		return "", err
	}
	return filepath.Join(currentWorkDir, DefaultLogFile), nil
}
