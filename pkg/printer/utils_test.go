package printer

import (
	"io/ioutil"
	"os"
	"testing"
	"time"

	"github.com/Checkmarx/kics/internal/console/flags"
	"github.com/spf13/cobra"
	"github.com/stretchr/testify/require"
)

func Test_PrintScanDuration(t *testing.T) {
	mockCmd := &cobra.Command{
		Use:   "mock",
		Short: "Mock cmd",
		RunE: func(cmd *cobra.Command, args []string) error {
			return nil
		},
	}

	tests := []struct {
		name                    string
		cmd                     *cobra.Command
		flagsListContent        string
		persintentFlag          bool
		supportedPlatforms      []string
		supportedCloudProviders []string
		elapsed                 time.Duration
		expected                string
	}{
		{
			name:                    "should print scan duration",
			cmd:                     mockCmd,
			flagsListContent:        "",
			persintentFlag:          true,
			supportedPlatforms:      []string{"terraform"},
			supportedCloudProviders: []string{"aws"},
			elapsed:                 time.Duration(1),
			expected:                "Scan duration: 1ns\n",
		},
		{
			name: "should print scan duration when ci flag is true",
			cmd:  mockCmd,
			flagsListContent: `{"ci": {
				"flagType": "bool",
				"shorthandFlag": "",
				"defaultValue": "true",
				"usage": "display only log messages to CLI output (mutually exclusive with silent)"
			}}`,
			persintentFlag:          true,
			supportedPlatforms:      []string{"terraform"},
			supportedCloudProviders: []string{"aws"},
			elapsed:                 time.Duration(1),
			expected:                "Scan duration: 0ms\n",
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			flags.InitJSONFlags(test.cmd, test.flagsListContent, test.persintentFlag, test.supportedPlatforms, test.supportedCloudProviders)

			rescueStdout := os.Stdout
			r, w, _ := os.Pipe()
			os.Stdout = w

			PrintScanDuration(test.elapsed)

			w.Close()
			out, _ := ioutil.ReadAll(r)
			os.Stdout = rescueStdout

			require.Equal(t, test.expected, string(out))
		})
	}
}
