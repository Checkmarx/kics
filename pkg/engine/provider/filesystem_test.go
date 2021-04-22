package provider

import (
	"context"
	"io"
	"io/fs"
	"os"
	"path/filepath"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	dockerParser "github.com/Checkmarx/kics/pkg/parser/docker"
	"github.com/Checkmarx/kics/test"
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
				path:     filepath.FromSlash("./test"),
				excludes: make(map[string][]os.FileInfo, 1),
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
		excludes map[string][]os.FileInfo
	}
	type args struct {
		ctx          context.Context
		queryName    string
		extensions   model.Extensions
		sink         Sink
		resolverSink ResolverSink
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
				path:     "../../../assets/queries",
				excludes: map[string][]os.FileInfo{},
			},
			args: args{
				ctx: nil,
				extensions: model.Extensions{
					".dockerfile": dockerParser.Parser{},
				},
				sink:         mockSink,
				resolverSink: mockErrResolverSink,
			},
			wantErr: false,
		},
		{
			name: "error_sink",
			fields: fields{
				path:     "../../../assets/queries",
				excludes: map[string][]os.FileInfo{},
			},
			args: args{
				ctx: nil,
				extensions: model.Extensions{
					".dockerfile": dockerParser.Parser{},
				},
				sink:         mockErrSink,
				resolverSink: mockErrResolverSink,
			},
			wantErr: false,
		},
		{
			name: "get_sources_file",
			fields: fields{
				path:     "../../../assets/queries/dockerfile/add_instead_of_copy/test/positive.dockerfile",
				excludes: map[string][]os.FileInfo{},
			},
			args: args{
				ctx: nil,
				extensions: model.Extensions{
					".dockerfile": dockerParser.Parser{},
				},
				sink:         mockSink,
				resolverSink: mockResolverSink,
			},
			wantErr: false,
		},
		{
			name: "error_not_suported_extension",
			fields: fields{
				path:     "../../../assets/queries/template/test/positive.tf",
				excludes: map[string][]os.FileInfo{},
			},
			args: args{
				ctx: nil,
				extensions: model.Extensions{
					".dockerfile": dockerParser.Parser{},
				},
				sink:         mockSink,
				resolverSink: mockResolverSink,
			},
			wantErr: true,
		},
		{
			name: "new_filesystem_source_provider_error",
			fields: fields{
				path:     "./no-path",
				excludes: map[string][]os.FileInfo{},
			},
			args: args{
				ctx:          nil,
				queryName:    "alb_protocol_is_http",
				extensions:   nil,
				sink:         mockSink,
				resolverSink: mockResolverSink,
			},
			wantErr: true,
		},
		{
			name: "err_resolver_sink",
			fields: fields{
				path:     "../../assets/queries/template/test/positive.tf",
				excludes: map[string][]os.FileInfo{},
			},
			args: args{
				ctx:       nil,
				queryName: "template",
				extensions: model.Extensions{
					".dockerfile": dockerParser.Parser{},
				},
				sink:         mockSink,
				resolverSink: mockErrResolverSink,
			},
			wantErr: true,
		},
		{
			name: "test_helm_source_provider",
			fields: fields{
				path:     "../../../test/fixtures/test_helm_subchart",
				excludes: map[string][]os.FileInfo{},
			},
			args: args{
				ctx: nil,
				extensions: model.Extensions{
					".dockerfile": dockerParser.Parser{},
				},
				sink:         mockSink,
				resolverSink: mockResolverSink,
			},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := &FileSystemSourceProvider{
				path:     tt.fields.path,
				excludes: tt.fields.excludes,
			}
			if err := s.GetSources(tt.args.ctx, tt.args.extensions, tt.args.sink, tt.args.resolverSink); (err != nil) != tt.wantErr {
				t.Errorf("FileSystemSourceProvider.GetSources() error = %v, wantErr %v", err, tt.wantErr)
			}
		})
	}
}

func TestFileSystemSourceProvider_GetBasePath(t *testing.T) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Errorf("failed to change dir: %s", err)
	}
	fsystem, err := initFs(filepath.FromSlash("test"), []string{})
	if err != nil {
		t.Errorf("failed to initialize a new File System Source Provider")
	}
	type feilds struct {
		fs *FileSystemSourceProvider
	}
	tests := []struct {
		name   string
		feilds feilds
		want   string
	}{
		{
			name: "test_get_base_path",
			feilds: feilds{
				fs: fsystem,
			},
			want: "test",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := tt.feilds.fs.GetBasePath()
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("GetBasePath() = %v, want = %v", got, tt.want)
			}
		})
	}
}

// TestFileSystemSourceProvider_checkConditions tests the functions [checkConditions()] and all the methods called by them
func TestFileSystemSourceProvider_checkConditions(t *testing.T) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Errorf("failed to change dir: %s", err)
	}
	infoFile, err := os.Stat(filepath.FromSlash("assets/queries"))
	checkStatErr(t, err)
	fileInfoSlice := []fs.FileInfo{
		infoFile,
	}
	infoHelm, errHelm := os.Stat(filepath.FromSlash("test/fixtures/test_helm"))
	checkStatErr(t, errHelm)
	type fields struct {
		path     string
		excludes map[string][]os.FileInfo
	}
	type args struct {
		info       os.FileInfo
		extensions model.Extensions
		path       string
	}
	type want struct {
		got bool
		err error
	}
	tests := []struct {
		name   string
		fields fields
		args   args
		want   want
	}{
		{
			name: "check_conditions",
			fields: fields{
				path:     filepath.FromSlash("assets/queries"),
				excludes: nil,
			},
			args: args{
				info: infoFile,
				extensions: model.Extensions{
					".dockerfile": dockerParser.Parser{},
				},
				path: filepath.FromSlash("assets/queries"),
			},
			want: want{
				got: true,
				err: nil,
			},
		},
		{
			name: "check_conditions_chart",
			fields: fields{
				path:     filepath.FromSlash("test/fixtures/test_helm"),
				excludes: nil,
			},
			args: args{
				info:       infoHelm,
				extensions: model.Extensions{},
				path:       filepath.FromSlash("test/fixtures/test_helm"),
			},
			want: want{
				got: false,
				err: nil,
			},
		},
		{
			name: "should_skip_folder",
			fields: fields{
				path: filepath.FromSlash("assets/queries"),
				excludes: map[string][]fs.FileInfo{
					"queries": fileInfoSlice,
				},
			},
			args: args{
				info: infoFile,
				extensions: model.Extensions{
					".dockerfile": dockerParser.Parser{},
				},
				path: filepath.FromSlash("assets/queries"),
			},
			want: want{
				got: true,
				err: filepath.SkipDir,
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := &FileSystemSourceProvider{
				path:     tt.fields.path,
				excludes: tt.fields.excludes,
			}
			if got, err := s.checkConditions(tt.args.info, tt.args.extensions, tt.args.path, false); got != tt.want.got || err != tt.want.err {
				t.Errorf("FileSystemSourceProvider.checkConditions() = %v, want %v", err, tt.want)
			}
		})
	}
}

// TestFileSystemSourceProvider_AddExcluded tests the functions [AddExcluded()] and all the methods called by them
func TestFileSystemSourceProvider_AddExcluded(t *testing.T) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Errorf("failed to change dir: %s", err)
	}
	fsystem, err := initFs(filepath.FromSlash("test"), []string{})
	if err != nil {
		t.Errorf("failed to initialize a new File System Source Provider")
	}
	type feilds struct {
		fs *FileSystemSourceProvider
	}
	type args struct {
		excludePaths []string
	}
	tests := []struct {
		name    string
		feilds  feilds
		args    args
		want    []string
		wantErr bool
	}{
		{
			name: "test_add_excluded",
			feilds: feilds{
				fs: fsystem,
			},
			args: args{
				excludePaths: []string{
					"test/fixtures/config_test",
				},
			},
			want: []string{
				"config_test",
			},
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := tt.feilds.fs.AddExcluded(tt.args.excludePaths)
			if (err != nil) != tt.wantErr {
				t.Errorf("AddExcluded() = %v, wantErr = %v", err, tt.wantErr)
			}
			got := getFSExcludes(tt.feilds.fs)
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("AddExcluded() = %v, want = %v", got, tt.want)
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

var mockResolverSink = func(ctx context.Context, filename string) ([]string, error) {
	return []string{}, nil
}

var mockErrResolverSink = func(ctx context.Context, filename string) ([]string, error) {
	return []string{}, errors.New("")
}

func checkStatErr(t *testing.T, err error) {
	if err != nil {
		t.Errorf("failed to get info: %s", err)
	}
}

// initFs creates a new instance of File System Source Provider
func initFs(path string, excluded []string) (*FileSystemSourceProvider, error) {
	return NewFileSystemSourceProvider(path, excluded)
}

func getFSExcludes(fsystem *FileSystemSourceProvider) []string {
	excluded := make([]string, 0)
	for key := range fsystem.excludes {
		excluded = append(excluded, key)
	}
	return excluded
}
