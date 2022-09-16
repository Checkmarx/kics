package scan

import (
	"io/ioutil"
	"os"
	"path/filepath"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	consolePrinter "github.com/Checkmarx/kics/pkg/printer"
	"github.com/stretchr/testify/require"
)

func Test_GetQueryPath(t *testing.T) {
	tests := []struct {
		name       string
		scanParams Parameters
		want       int
	}{
		{
			name: "multiple queries path",
			scanParams: Parameters{
				QueriesPath: []string{
					filepath.Join("..", "..", "assets", "queries", "terraform", "aws"),
					filepath.Join("..", "..", "assets", "queries", "terraform", "azure"),
				},
				ChangedDefaultQueryPath: true,
			},
			want: 2,
		},
		{
			name: "single query path",
			scanParams: Parameters{
				QueriesPath: []string{
					filepath.Join("..", "..", "assets", "queries", "terraform", "aws"),
				},
				ChangedDefaultQueryPath: true,
			},
			want: 1,
		},
		{
			name: "default query path",
			scanParams: Parameters{
				QueriesPath: []string{filepath.Join("..", "..", "assets", "queries")},
			},
			want: 1,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			client := Client{
				ScanParams: &tt.scanParams,
			}

			client.GetQueryPath()

			if got := client.ScanParams.QueriesPath; !reflect.DeepEqual(len(got), tt.want) {
				t.Errorf("GetQueryPath() = %v, want %v", len(got), tt.want)
			}
		})
	}
}

func Test_PrintVersionCheck(t *testing.T) {
	tests := []struct {
		name           string
		consolePrinter *consolePrinter.Printer
		modelSummary   *model.Summary
		expectedOutput string
	}{
		{
			name:           "test latest version",
			consolePrinter: consolePrinter.NewPrinter(true),
			modelSummary: &model.Summary{
				Version: "v1.0.0",
				LatestVersion: model.Version{
					Latest:           true,
					LatestVersionTag: "1.0.0",
				},
			},
			expectedOutput: "",
		},
		{
			name:           "test outdated version",
			consolePrinter: consolePrinter.NewPrinter(true),
			modelSummary: &model.Summary{
				Version: "v1.0.0",
				LatestVersion: model.Version{
					Latest:           false,
					LatestVersionTag: "1.1.0",
				},
			},
			expectedOutput: "A new version 'v1.1.0' of KICS is available, please consider updating\n",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			rescueStdout := os.Stdout
			r, w, _ := os.Pipe()
			os.Stdout = w

			printVersionCheck(tt.consolePrinter, tt.modelSummary)

			w.Close()
			out, _ := ioutil.ReadAll(r)
			os.Stdout = rescueStdout

			require.Equal(t, tt.expectedOutput, string(out))
		})
	}
}

func Test_ContributionAppeal(t *testing.T) {
	tests := []struct {
		name           string
		consolePrinter *consolePrinter.Printer
		queriesPath    []string
		expectedOutput string
	}{
		{
			name:           "test custom query",
			consolePrinter: consolePrinter.NewPrinter(true),
			queriesPath:    []string{filepath.Join("custom", "query", "path")},
			expectedOutput: "\nAre you using a custom query? If so, feel free to contribute to KICS!\nCheck out how to do it: https://github.com/Checkmarx/kics/blob/master/docs/CONTRIBUTING.md\n\n",
		},
		{
			name:           "test non custom query",
			consolePrinter: consolePrinter.NewPrinter(true),
			queriesPath:    []string{filepath.Join("assets", "queries", "path")},
			expectedOutput: "",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			rescueStdout := os.Stdout
			r, w, _ := os.Pipe()
			os.Stdout = w

			contributionAppeal(tt.consolePrinter, tt.queriesPath)

			w.Close()
			out, _ := ioutil.ReadAll(r)
			os.Stdout = rescueStdout

			require.Equal(t, tt.expectedOutput, string(out))
		})
	}

}
