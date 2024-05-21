package remediation

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/Checkmarx/kics/v2/internal/console/flags"
	"github.com/Checkmarx/kics/v2/pkg/engine/source"
	"github.com/Checkmarx/kics/v2/pkg/utils"
	"github.com/spf13/cobra"
	"github.com/stretchr/testify/require"
)

func Test_RemediateFile(t *testing.T) {

	filePathCopyFrom := filepath.Join("..", "..", "test", "fixtures", "kics_auto_remediation", "terraform.tf")

	type args struct {
		remediate Set
	}

	replacement := &Remediation{
		Line:         5,
		Remediation:  "{\"after\":\"true\",\"before\":\"false\"}",
		SimilarityID: "87abbee5d0ec977ba193371c702dca2c040ea902d2e606806a63b66119ff89bc",
		QueryID:      "41a38329-d81b-4be4-aef4-55b2615d3282",
	}

	var r1, r2, r3 Set
	r1.Replacement = append(r1.Replacement, *replacement)

	addition := &Remediation{
		Line:         1,
		Remediation:  "minimum_password_length = 14",
		SimilarityID: "f282fa13cf5e4ffd4bbb0ee2059f8d0240edcd2ca54b3bb71633145d961de5ce",
		QueryID:      "a9dfec39-a740-4105-bbd6-721ba163c053",
	}

	r2.Replacement = append(r2.Replacement, *replacement)
	r2.Addition = append(r2.Addition, *addition)

	wrongReplacement := &Remediation{
		Line:         5,
		Remediation:  "{\"after\":\"false\",\"before\":\"false\"}",
		SimilarityID: "87abbee5d0ec977ba193371c702dca2c040ea902d2e606806a63b66119ff89bc",
		QueryID:      "41a38329-d81b-4be4-aef4-55b2615d3282",
	}

	r3.Replacement = append(r3.Replacement, *wrongReplacement)

	tests := []struct {
		name                        string
		args                        args
		actualRemediationDoneNumber int
	}{
		{
			name: "remediate a file with a replacement",
			args: args{
				remediate: r1,
			},
			actualRemediationDoneNumber: 1,
		},
		{
			name: "remediate a file with a replacement and addition",
			args: args{
				remediate: r2,
			},
			actualRemediationDoneNumber: 2,
		},
		{
			name: "remediate a file without any remediation",
			args: args{
				remediate: Set{},
			},
			actualRemediationDoneNumber: 0,
		},
		{
			name: "remediate a file with a wrong remediation",
			args: args{
				remediate: r3,
			},
			actualRemediationDoneNumber: 0,
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

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := &Summary{
				SelectedRemediationNumber:   0,
				ActualRemediationDoneNumber: 0,
			}

			tmpFileName := filepath.Join(os.TempDir(), "temporary-remediation"+utils.NextRandom()+filepath.Ext(filePathCopyFrom))
			tmpFile := CreateTempFile(filePathCopyFrom, tmpFileName)
			s.RemediateFile(tmpFile, tt.args.remediate, false, 15)

			os.Remove(tmpFile)
			require.Equal(t, s.ActualRemediationDoneNumber, tt.actualRemediationDoneNumber)

		})
	}
}
