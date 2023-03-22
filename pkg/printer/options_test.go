package printer

import (
	"io"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"testing"

	"github.com/rs/zerolog"
	"github.com/stretchr/testify/require"
)

func TestOptions_LogPath(t *testing.T) {
	type args struct {
		opt string
	}
	tests := []struct {
		name    string
		args    args
		wantErr bool
	}{
		{
			name: "test_log_path",
			args: args{
				"",
			},
			wantErr: false,
		},
		{
			name: "test_log_path_error",
			args: args{
				"kics/results.json",
			},
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := LogPath(tt.args.opt, true)
			if (err != nil) != tt.wantErr {
				t.Errorf("LogPath() = %v, wantErr = %v", err, tt.wantErr)
			} else if tt.args.opt != "" {
				require.FileExists(t, filepath.FromSlash(tt.args.opt))
				os.RemoveAll(filepath.Dir(filepath.FromSlash(tt.args.opt)))
			}
		})
	}
}

func TestOptions_LogLevel(t *testing.T) {
	type args struct {
		opt string
	}
	tests := []struct {
		name    string
		args    args
		wantErr bool
		want    string
	}{
		{
			name: "test_log_level_trace",
			args: args{
				"TRACE",
			},
			wantErr: false,
			want:    "TRACE",
		},
		{
			name: "test_log_level_debug",
			args: args{
				"DEBUG",
			},
			wantErr: false,
			want:    "DEBUG",
		},
		{
			name: "test_log_level_info",
			args: args{
				"INFO",
			},
			wantErr: false,
			want:    "INFO",
		},
		{
			name: "test_log_level_warn",
			args: args{
				"WARN",
			},
			wantErr: false,
			want:    "WARN",
		},
		{
			name: "test_log_level_error",
			args: args{
				"ERROR",
			},
			wantErr: false,
			want:    "ERROR",
		},
		{
			name: "test_log_level_fatal",
			args: args{
				"FATAL",
			},
			wantErr: false,
			want:    "FATAL",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := LogLevel(tt.args.opt, true)
			if (err != nil) != tt.wantErr {
				t.Errorf("LogLevel = %v, wantErr = %v", err, tt.wantErr)
			}
			got := zerolog.GlobalLevel().String()
			if !reflect.DeepEqual(strings.ToLower(got), strings.ToLower(tt.want)) {
				t.Errorf("LogLevel = %v, want = %v", got, tt.want)
			}
		})
	}
}

func TestOptions_CI(t *testing.T) {
	res := os.Stdout
	defer func() {
		os.Stdout = res
	}()
	type args struct {
		opt bool
	}
	tests := []struct {
		name    string
		args    args
		wantErr bool
		want    zerolog.ConsoleWriter
	}{
		{
			name: "test_ci",
			args: args{
				opt: true,
			},
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			outConsoleLogger = io.Discard
			outFileLogger = io.Discard
			err := CI(tt.args.opt)
			if (err != nil) != tt.wantErr {
				t.Errorf("CI() = %v, wantErr = %v", err, tt.wantErr)
			}
		})
	}
}

func TestOptions_Verbose(t *testing.T) {
	type args struct {
		opt bool
	}
	tests := []struct {
		name    string
		args    args
		wantErr bool
		want    zerolog.ConsoleWriter
	}{
		{
			name: "test_verbose",
			args: args{
				opt: true,
			},
			wantErr: false,
			want:    zerolog.ConsoleWriter{Out: os.Stdout},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := Verbose(tt.args.opt, true)
			if (err != nil) != tt.wantErr {
				t.Errorf("Verbose() = %v, wantErr = %v", err, tt.wantErr)
			}
			got := consoleLogger
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("Verbose() = %v, want = %v", got, tt.want)
			}
		})
	}
}

func TestOptions_LogFile(t *testing.T) {
	type args struct {
		opt bool
	}
	tests := []struct {
		name    string
		args    args
		wantErr bool
		want    zerolog.ConsoleWriter
	}{
		{
			name: "test_log_file",
			args: args{
				opt: true,
			},
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := LogFile(tt.args.opt, true)
			if (err != nil) != tt.wantErr {
				t.Errorf("LogFile() = %v, wantErr = %v", err, tt.wantErr)
			}
		})
	}
}

func TestOptions_LogFormat(t *testing.T) {
	type args struct {
		opt string
	}
	tests := []struct {
		name    string
		args    args
		wantErr bool
	}{
		{
			name: "test_log_format_json",
			args: args{
				opt: "json",
			},
			wantErr: false,
		},
		{
			name: "test_log_format_pretty",
			args: args{
				opt: "pretty",
			},
			wantErr: false,
		},
		{
			name: "test_log_format_error",
			args: args{
				opt: "error",
			},
			wantErr: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := LogFormat(tt.args.opt)
			if (err != nil) != tt.wantErr {
				t.Errorf("LogFormat() = %v, wantErr = %v", err, tt.wantErr)
			}
		})
	}
}

func TestOptions_NoColor(t *testing.T) {
	type args struct {
		opt bool
	}
	tests := []struct {
		name    string
		args    args
		wantErr bool
		want    bool
	}{
		{
			name: "test_no_color",
			args: args{
				true,
			},
			wantErr: false,
			want:    true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := NoColor(tt.args.opt, true)
			if (err != nil) != tt.wantErr {
				t.Errorf("NoColor() = %v, wantErr = %v", err, tt.wantErr)
			}
			got := consoleLogger.NoColor
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("NoColor() consoleLogger.NoColor = %v, want = %v", got, tt.want)
			}
		})
	}
}
