package remediation

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/Checkmarx/kics/internal/console/flags"
	"github.com/Checkmarx/kics/pkg/engine/source"
	"github.com/Checkmarx/kics/pkg/utils"
	"github.com/spf13/cobra"
	"github.com/stretchr/testify/require"
)

func Test_RemediateFile(t *testing.T) {

	filePath := filepath.Join("..", "..", "test", "fixtures", "kics_auto_remediation", "terraform.tf")

	type args struct {
		fix Fix
	}

	replacement := &Remediation{
		Line:         5,
		Remediation:  "{\"after\":\"true\",\"before\":\"false\"}",
		SimilarityID: "87abbee5d0ec977ba193371c702dca2c040ea902d2e606806a63b66119ff89bc",
		QueryID:      "41a38329-d81b-4be4-aef4-55b2615d3282",
	}

	var fix1, fix2, fix3 Fix
	fix1.Replacement = append(fix1.Replacement, *replacement)

	addition := &Remediation{
		Line:         1,
		Remediation:  "minimum_password_length = 14",
		SimilarityID: "f282fa13cf5e4ffd4bbb0ee2059f8d0240edcd2ca54b3bb71633145d961de5ce",
		QueryID:      "a9dfec39-a740-4105-bbd6-721ba163c053",
	}

	fix2.Replacement = append(fix2.Replacement, *replacement)
	fix2.Addition = append(fix2.Addition, *addition)

	wrongReplacement := &Remediation{
		Line:         5,
		Remediation:  "{\"after\":\"false\",\"before\":\"false\"}",
		SimilarityID: "87abbee5d0ec977ba193371c702dca2c040ea902d2e606806a63b66119ff89bc",
		QueryID:      "41a38329-d81b-4be4-aef4-55b2615d3282",
	}

	fix3.Replacement = append(fix3.Replacement, *wrongReplacement)

	tests := []struct {
		name                         string
		args                         args
		actualRemediationsDoneNumber int
	}{
		{
			name: "remediate a file with a replacement",
			args: args{
				fix: fix1,
			},
			actualRemediationsDoneNumber: 1,
		},
		{
			name: "remediate a file with a replacement and addition",
			args: args{
				fix: fix2,
			},
			actualRemediationsDoneNumber: 2,
		},
		{
			name: "remediate a file without any remediation",
			args: args{
				fix: Fix{},
			},
			actualRemediationsDoneNumber: 0,
		},
		{
			name: "remediate a file with a wrong remediation",
			args: args{
				fix: fix3,
			},
			actualRemediationsDoneNumber: 0,
		},
	}

	mockCmd := &cobra.Command{
		Use:   "mock",
		Short: "Mock cmd",
		RunE: func(cmd *cobra.Command, args []string) error {
			return nil
		},
	}

	data, err := os.ReadFile(filepath.FromSlash("../../internal/console/assets/scan-flags.json"))
	require.NoError(t, err)
	flags.InitJSONFlags(
		mockCmd,
		string(data),
		true,
		source.ListSupportedPlatforms(),
		source.ListSupportedCloudProviders(),
	)

	flags.SetMultiStrFlag(flags.QueriesPath, []string{"../../assets/queries"})

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := &Summary{
				SelectedRemediationsNumber:   0,
				ActualRemediationsDoneNumber: 0,
			}

			tmpFile := createTempFile(filePath)
			s.RemediateFile(tmpFile, tt.args.fix)

			os.Remove(tmpFile)
			require.Equal(t, s.ActualRemediationsDoneNumber, tt.actualRemediationsDoneNumber)

		})
	}
}

func createTempFile(filePath string) string {
	// create temporary file
	tmpFile := filepath.Join(os.TempDir(), "temporary-remediation"+utils.NextRandom()+filepath.Ext(filePath))
	f, err := os.OpenFile(tmpFile, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.ModePerm)

	if err != nil {
		f.Close()
		return ""
	}

	content, err := os.ReadFile(filePath)
	if err != nil {
		return ""
	}

	if _, err = f.Write(content); err != nil {
		f.Close()
		return ""
	}
	return tmpFile
}
