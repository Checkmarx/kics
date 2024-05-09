package helpers

import (
	"os"
	"path/filepath"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/progress"
	"github.com/Checkmarx/kics/v2/test"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/require"
)

func TestFileAnalyzer(t *testing.T) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}

	tests := []struct {
		name    string
		arg     string
		want    string
		wantErr bool
	}{
		{
			name:    "file_analyzer_json",
			arg:     "test/fixtures/config_test/kics.json",
			want:    "json",
			wantErr: false,
		},
		{
			name:    "file_analyzer_json_no_extension",
			arg:     "test/fixtures/config_test/kics.config_json",
			want:    "json",
			wantErr: false,
		},
		{
			name:    "file_analyzer_yaml",
			arg:     "test/fixtures/config_test/kics.yaml",
			want:    "yaml",
			wantErr: false,
		},
		{
			name:    "file_analyzer_yaml_no_extension",
			arg:     "test/fixtures/config_test/kics.config_yaml",
			want:    "yaml",
			wantErr: false,
		},
		{
			name:    "file_analyzer_hcl",
			arg:     "test/fixtures/config_test/kics.hcl",
			want:    "hcl",
			wantErr: false,
		},
		{
			name:    "file_analyzer_hcl_no_extension",
			arg:     "test/fixtures/config_test/kics.config_hcl",
			want:    "hcl",
			wantErr: false,
		},
		{
			name:    "file_analyzer_toml",
			arg:     "test/fixtures/config_test/kics.toml",
			want:    "toml",
			wantErr: false,
		},
		{
			name:    "file_analyzer_toml_no_extension",
			arg:     "test/fixtures/config_test/kics.config_toml",
			want:    "toml",
			wantErr: false,
		},
		{
			name:    "file_analyzer_js_incorrect",
			arg:     "test/fixtures/config_test/kics.config_js",
			want:    "",
			wantErr: true,
		},
		{
			name:    "file_analyzer_js_no_extension_incorrect",
			arg:     "test/fixtures/config_test/kics.js",
			want:    "",
			wantErr: true,
		},
		{
			name:    "file_analyzer_js_wrong_extension",
			arg:     "test/fixtures/config_test/kics_wrong.js",
			want:    "yaml",
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := FileAnalyzer(tt.arg)
			if (err != nil) != tt.wantErr {
				t.Errorf("FileAnalyzer() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("FileAnalyzer() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestFileAnalyzer_Error_File(t *testing.T) {
	_, err := FileAnalyzer(filepath.FromSlash("test/fixtures/config_test/kicsNoFileExists.js"))
	require.Error(t, err)
}

func TestHelpers_GenerateReport(t *testing.T) {
	type args struct {
		path     string
		filename string
		body     interface{}
		formats  []string
	}
	tests := []struct {
		name    string
		args    args
		wantErr bool
		remove  []string
	}{
		{
			name: "test_generate_report",
			args: args{
				path:     ".",
				filename: "result",
				body:     "",
				formats:  []string{"json"},
			},
			wantErr: false,
			remove:  []string{"result.json"},
		},
		{
			name: "test_generate_report_error",
			args: args{
				path:     ".",
				filename: "result",
				body:     "",
				formats:  []string{"html"},
			},
			wantErr: true,
			remove:  []string{"result.html"},
		},
		{
			name: "test_generate_report_error",
			args: args{
				path:     ".",
				filename: "result",
				body:     "",
				formats:  []string{"sarif"},
			},
			wantErr: false,
			remove:  []string{"result.sarif"},
		},
		{
			name: "test_generate_report_error",
			args: args{
				path:     ".",
				filename: "result",
				body:     "",
				formats:  []string{"glsast"},
			},
			wantErr: false,
			remove:  []string{"gl-sast-result.json"},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := GenerateReport(tt.args.path, tt.args.filename, tt.args.body, tt.args.formats, progress.PbBuilder{})
			if (err != nil) != tt.wantErr {
				t.Errorf("GenerateReport() = %v, wantErr = %v", err, tt.wantErr)
			}
			for _, file := range tt.remove {
				err := os.Remove(filepath.Join(tt.args.path, file))
				require.NoError(t, err)
			}
		})
	}
}

func TestHelpers_GetDefaultQueryPath(t *testing.T) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}

	cd, err := os.Getwd()
	require.NoError(t, err)

	tests := []struct {
		name        string
		queriesPath string
		want        string
		wantErr     bool
	}{
		{
			name:        "test_get_default_query_path",
			queriesPath: filepath.FromSlash("assets/queries"),
			want:        filepath.Join(cd, filepath.FromSlash("assets/queries")),
			wantErr:     false,
		},
		{
			name:        "test_get_default_query_path_error",
			queriesPath: filepath.FromSlash("error"),
			want:        "",
			wantErr:     true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := GetDefaultQueryPath(tt.queriesPath)
			if (err != nil) != tt.wantErr {
				t.Errorf("GetDefaultQueryPath() = %v, wantErr = %v", err, tt.wantErr)
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("GetDefaultQueryPath() = %v, want = %v", got, tt.want)
			}
		})
	}
}

func TestHelpers_ListReportFormats(t *testing.T) {
	formats := ListReportFormats()
	for _, format := range formats {
		_, ok := reportGenerators[format]
		require.True(t, ok)
	}
}

func TestHelpers_GetNumCPU(t *testing.T) {
	cpu := GetNumCPU()
	require.NotEqual(t, cpu, nil)
}

func TestHelpers_CustomConsoleWriter(t *testing.T) {
	v := CustomConsoleWriter(&zerolog.ConsoleWriter{NoColor: true})
	require.IsType(t, zerolog.ConsoleWriter{}, v)
}
