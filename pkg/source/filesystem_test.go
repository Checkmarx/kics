package source

import (
	"context"
	"io"
	"os"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	dockerParser "github.com/Checkmarx/kics/pkg/parser/docker"
	"github.com/pkg/errors"
)

// TestNewFileSystemSourceProvider tests the functions [NewFileSystemSourceProvider()] and all the methods called by them
func TestNewFileSystemSourceProvider(t *testing.T) {
	type args struct {
		path     string
		excludes []string
	}
	tests := []struct {
		name    string
		args    args
		want    *FileSystemSourceProvider
		wantErr bool
	}{
		{
			name: "new_filesystem_source_provider",
			args: args{
				path: "./test",
				excludes: []string{
					".tf",
				},
			},
			want: &FileSystemSourceProvider{
				path:     "./test",
				excludes: make(map[string]os.FileInfo, 1),
			},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := NewFileSystemSourceProvider(tt.args.path, tt.args.excludes)
			if (err != nil) != tt.wantErr {
				t.Errorf("NewFileSystemSourceProvider() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("NewFileSystemSourceProvider() = %v, want %v", got, tt.want)
			}
		})
	}
}

// TestFileSystemSourceProvider_GetSources tests the functions [GetSources()] and all the methods called by them
func TestFileSystemSourceProvider_GetSources(t *testing.T) { //nolint
	type fields struct {
		path     string
		excludes map[string]os.FileInfo
	}
	type args struct {
		ctx        context.Context
		in1        string
		extensions model.Extensions
		sink       Sink
	}
	tests := []struct {
		name    string
		fields  fields
		args    args
		wantErr bool
	}{
		{
			name: "get_sources",
			fields: fields{
				path:     "../../assets/queries",
				excludes: map[string]os.FileInfo{},
			},
			args: args{
				ctx: nil,
				in1: "alb_protocol_is_http",
				extensions: model.Extensions{
					".dockerfile": dockerParser.Parser{},
				},
				sink: mockSink,
			},
			wantErr: false,
		},
		{
			name: "error_sink",
			fields: fields{
				path:     "../../assets/queries",
				excludes: map[string]os.FileInfo{},
			},
			args: args{
				ctx: nil,
				in1: "alb_protocol_is_http",
				extensions: model.Extensions{
					".dockerfile": dockerParser.Parser{},
				},
				sink: mockErrSink,
			},
			wantErr: false,
		},
		{
			name: "get_sources_file",
			fields: fields{
				path:     "../../assets/queries/dockerfile/add_instead_of_copy/test/positive.dockerfile",
				excludes: map[string]os.FileInfo{},
			},
			args: args{
				ctx: nil,
				in1: "add_instead_of_copy",
				extensions: model.Extensions{
					".dockerfile": dockerParser.Parser{},
				},
				sink: mockSink,
			},
			wantErr: false,
		},
		{
			name: "error_not_suported_extension",
			fields: fields{
				path:     "../../assets/queries/template/test/positive.tf",
				excludes: map[string]os.FileInfo{},
			},
			args: args{
				ctx: nil,
				in1: "template",
				extensions: model.Extensions{
					".dockerfile": dockerParser.Parser{},
				},
				sink: mockSink,
			},
			wantErr: true,
		},
		{
			name: "new_filesystem_source_provider_error",
			fields: fields{
				path:     "./no-path",
				excludes: map[string]os.FileInfo{},
			},
			args: args{
				ctx:        nil,
				in1:        "alb_protocol_is_http",
				extensions: nil,
				sink:       mockSink,
			},
			wantErr: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := &FileSystemSourceProvider{
				path:     tt.fields.path,
				excludes: tt.fields.excludes,
			}
			if err := s.GetSources(tt.args.ctx, tt.args.in1, tt.args.extensions, tt.args.sink); (err != nil) != tt.wantErr {
				t.Errorf("FileSystemSourceProvider.GetSources() error = %v, wantErr %v", err, tt.wantErr)
			}
		})
	}
}

// TestFileSystemSourceProvider_checkConditions tests the functions [checkConditions()] and all the methods called by them
func TestFileSystemSourceProvider_checkConditions(t *testing.T) {
	infoFile, _ := os.Stat("../../assets/queries")
	type fields struct {
		path     string
		excludes map[string]os.FileInfo
	}
	type args struct {
		info       os.FileInfo
		extensions model.Extensions
		path       string
	}
	tests := []struct {
		name   string
		fields fields
		args   args
		want   bool
	}{
		{
			name: "check_conditions",
			fields: fields{
				path:     "../../assets/queries",
				excludes: nil,
			},
			args: args{
				info: infoFile,
				extensions: model.Extensions{
					".dockerfile": dockerParser.Parser{},
				},
				path: "../../assets/queries",
			},
			want: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := &FileSystemSourceProvider{
				path:     tt.fields.path,
				excludes: tt.fields.excludes,
			}
			if got := s.checkConditions(tt.args.info, tt.args.extensions, tt.args.path); got != tt.want {
				t.Errorf("FileSystemSourceProvider.checkConditions() = %v, want %v", got, tt.want)
			}
		})
	}
}

var mockSink = func(ctx context.Context, filename string, content io.ReadCloser) error {
	return nil
}

var mockErrSink = func(ctx context.Context, filename string, content io.ReadCloser) error {
	return errors.New("")
}
