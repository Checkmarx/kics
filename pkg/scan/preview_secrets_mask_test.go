package scan

import (
	"github.com/Checkmarx/kics/v2/pkg/engine/secrets"
	"strings"
	"testing"

	"github.com/Checkmarx/kics/v2/internal/tracker"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/printer"
	"github.com/Checkmarx/kics/v2/pkg/progress"
	"github.com/stretchr/testify/require"
)

func Test_maskSecrets(t *testing.T) {
	tests := []struct {
		name           string
		filename       string
		scanParameters Parameters
		tracker        tracker.CITracker
		scanResults    *Results
	}{
		{
			name:     "print with masked secrets",
			filename: "results",
			scanParameters: Parameters{
				DisableSecrets: true,
			},
			tracker: tracker.CITracker{
				FoundFiles:         1,
				FoundCountLines:    9,
				ParsedCountLines:   9,
				IgnoreCountLines:   0,
				ParsedFiles:        1,
				LoadedQueries:      146,
				ExecutingQueries:   146,
				ExecutedQueries:    146,
				FailedSimilarityID: 0,
				Version: model.Version{
					Latest:           true,
					LatestVersionTag: "Dev",
				},
			},
			scanResults: &Results{
				Results: []model.Vulnerability{
					{
						VulnLines: &[]model.CodeLine{
							{
								Position: 4,
								Line:     " metadata:",
							},
							{
								Position: 5,
								Line:     "   name: secret-basic-auth:",
							}, {
								Position: 6,
								Line:     "  password: \"abcd\"",
							},
						},
					},
				},
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := Client{}
			c.Tracker = &tt.tracker
			c.ScanParams = &tt.scanParameters
			c.ProBarBuilder = progress.InitializePbBuilder(true, false, true)
			c.Printer = printer.NewPrinter(true)

			err := c.postScan(tt.scanResults)
			require.NoError(t, err)

			for _, line := range (*tt.scanResults).Results {
				for _, vulnLine := range *line.VulnLines {
					if strings.Contains(vulnLine.Line, "password") {
						require.Contains(t, vulnLine.Line, secrets.SecretMask)
					}
				}
			}

		})

	}
}

func Test_maskSecretsEntropies(t *testing.T) {
	tests := []struct {
		name           string
		filename       string
		scanParameters Parameters
		tracker        tracker.CITracker
		scanResults    *Results
	}{
		{
			name:     "not print with masked secrets with invalid entropies",
			filename: "results",
			scanParameters: Parameters{
				DisableSecrets: true,
			},
			tracker: tracker.CITracker{
				FoundFiles:         1,
				FoundCountLines:    9,
				ParsedCountLines:   9,
				IgnoreCountLines:   0,
				ParsedFiles:        1,
				LoadedQueries:      146,
				ExecutingQueries:   146,
				ExecutedQueries:    146,
				FailedSimilarityID: 0,
				Version: model.Version{
					Latest:           true,
					LatestVersionTag: "Dev",
				},
			},
			scanResults: &Results{
				Results: []model.Vulnerability{
					{
						VulnLines: &[]model.CodeLine{
							{
								Position: 4,
								Line:     "secret = \"eeeeee\"",
							},
						},
					},
				},
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := Client{}
			c.Tracker = &tt.tracker
			c.ScanParams = &tt.scanParameters
			c.ProBarBuilder = progress.InitializePbBuilder(true, false, true)
			c.Printer = printer.NewPrinter(true)

			err := c.postScan(tt.scanResults)
			require.NoError(t, err)

			for _, line := range (*tt.scanResults).Results {
				for _, vulnLine := range *line.VulnLines {
					require.NotContains(t, vulnLine.Line, secrets.SecretMask)

				}
			}

		})

	}
}
