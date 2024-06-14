package provider

import (
	"context"
	"io"
	"io/fs"
	"os"
	"path/filepath"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	dockerParser "github.com/Checkmarx/kics/v2/pkg/parser/docker"
	"github.com/Checkmarx/kics/v2/test"
	"github.com/pkg/errors"
	"github.com/stretchr/testify/require"
)

// TestNewFileSystemSourceProvider tests the functions [NewFileSystemSourceProvider()] and all the methods called by them
func TestNewFileSystemSourceProvider(t *testing.T) {
	type args struct {
		paths    []string
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
				paths: []string{"./test"},
				excludes: []string{
					".tf",
				},
			},
			want: &FileSystemSourceProvider{
				paths:    []string{filepath.FromSlash("./test")},
				excludes: make(map[string][]os.FileInfo, 1),
			},
			wantErr: false,
		},
		{
			name: "new_filesystem_source_provider",
			args: args{
				paths: []string{"./test", "./test2"},
				excludes: []string{
					".tf",
				},
			},
			want: &FileSystemSourceProvider{
				paths:    []string{filepath.FromSlash("./test"), filepath.FromSlash("./test2")},
				excludes: make(map[string][]os.FileInfo, 1),
			},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := NewFileSystemSourceProvider(tt.args.paths, tt.args.excludes)
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
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}
	type fields struct {
		paths    []string
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
				paths:    []string{"assets/queries"},
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
				paths:    []string{"assets/queries"},
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
				paths:    []string{"assets/queries/dockerfile/add_instead_of_copy/test/positive.dockerfile"},
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
				paths:    []string{"assets/queries/template/test/positive.tf"},
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
				paths:    []string{"./no-path"},
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
				paths:    []string{"assets/queries/template/test/positive.tf"},
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
				paths:    []string{"test/fixtures/test_helm_subchart"},
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
				paths:    tt.fields.paths,
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
	fsystem, err := initFs([]string{filepath.FromSlash("test")}, []string{})
	if err != nil {
		t.Errorf("failed to initialize a new File System Source Provider")
	}
	fsystem2, err := initFs([]string{filepath.FromSlash("test"), filepath.FromSlash("test2")}, []string{})
	if err != nil {
		t.Errorf("failed to initialize a new File System Source Provider")
	}
	type fields struct {
		fs *FileSystemSourceProvider
	}
	tests := []struct {
		name   string
		fields fields
		want   []string
	}{
		{
			name: "test_get_base_path",
			fields: fields{
				fs: fsystem,
			},
			want: []string{"test"},
		},
		{
			name: "test_get_base_path_multiples",
			fields: fields{
				fs: fsystem2,
			},
			want: []string{"test", "test2"},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := tt.fields.fs.GetBasePaths()
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
	infoHelmTerra, errHelmTerra := os.Stat(filepath.FromSlash("test/fixtures/terra/test_helm"))
	checkStatErr(t, errHelmTerra)
	infoTerraCache, errTerraCache := os.Stat(filepath.FromSlash("test/fixtures/test_terra_cache"))
	checkStatErr(t, errTerraCache)
	infoTerraCacheFolder, errTerraCacheFolder := os.Stat(filepath.FromSlash("test/fixtures/test_terra_cache/.terraform"))
	checkStatErr(t, errTerraCacheFolder)

	type fields struct {
		paths    []string
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
				paths:    []string{filepath.FromSlash("assets/queries")},
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
				paths:    []string{filepath.FromSlash("test/fixtures/test_helm")},
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
			name: "check_conditions_chart, with terra on path not skip",
			fields: fields{
				paths:    []string{filepath.FromSlash("test/fixtures/terra/test_helm")},
				excludes: nil,
			},
			args: args{
				info:       infoHelmTerra,
				extensions: model.Extensions{},
				path:       filepath.FromSlash("test/fixtures/terra/test_helm"),
			},
			want: want{
				got: false,
				err: nil,
			},
		},
		{
			name: "should_skip_folder",
			fields: fields{
				paths: []string{filepath.FromSlash("assets/queries")},
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
		{
			name: "check_condition_ignore_terra_cache for .terra",
			fields: fields{
				paths:    []string{filepath.FromSlash(".terra")},
				excludes: nil,
			},
			args: args{
				info:       infoTerraCache,
				extensions: model.Extensions{},
				path:       filepath.FromSlash(".terra"),
			},
			want: want{
				got: true,
				err: filepath.SkipDir,
			},
		},
		{
			name: "check_condition_ignore_terragrunt_cache for .terragrunt-cache",
			fields: fields{
				paths:    []string{filepath.FromSlash(".terragrunt-cache")},
				excludes: nil,
			},
			args: args{
				info:       infoTerraCache,
				extensions: model.Extensions{},
				path:       filepath.FromSlash(".terragrunt-cache"),
			},
			want: want{
				got: true,
				err: filepath.SkipDir,
			},
		},
		{
			name: "check_condition_ignore_terra_cache for terra, exclude by missing chart.yaml",
			fields: fields{
				paths:    []string{filepath.FromSlash("terra")},
				excludes: nil,
			},
			args: args{
				info:       infoTerraCache,
				extensions: model.Extensions{},
				path:       filepath.FromSlash("terra"),
			},
			want: want{
				got: true,
				err: nil,
			},
		},
		{
			name: "check_condition_ignore_terra_cache for .terraform",
			fields: fields{
				paths:    []string{filepath.FromSlash(".terraform")},
				excludes: nil,
			},
			args: args{
				info:       infoTerraCache,
				extensions: model.Extensions{},
				path:       filepath.FromSlash(".terraform"),
			},
			want: want{
				got: true,
				err: filepath.SkipDir,
			},
		},
		{
			name: "check_condition_ignore_terra_cache for .terraform, exclude by missing chart.yaml",
			fields: fields{
				paths:    []string{filepath.FromSlash("terraform")},
				excludes: nil,
			},
			args: args{
				info:       infoTerraCache,
				extensions: model.Extensions{},
				path:       filepath.FromSlash("terraform"),
			},
			want: want{
				got: true,
				err: nil,
			},
		},
		{
			name: "check_condition_ignore_terra_cache for .terra/lalala",
			fields: fields{
				paths:    []string{filepath.FromSlash(".terra/lalala")},
				excludes: nil,
			},
			args: args{
				info:       infoTerraCache,
				extensions: model.Extensions{},
				path:       filepath.FromSlash(".terra/lalala"),
			},
			want: want{
				got: true,
				err: filepath.SkipDir,
			},
		},
		{
			name: "check_condition_ignore_terragrunt_cache for .terragrunt-cache/lalala",
			fields: fields{
				paths:    []string{filepath.FromSlash(".terragrunt-cache/lalala")},
				excludes: nil,
			},
			args: args{
				info:       infoTerraCache,
				extensions: model.Extensions{},
				path:       filepath.FromSlash(".terragrunt-cache/lalala"),
			},
			want: want{
				got: true,
				err: filepath.SkipDir,
			},
		},
		{
			name: "check_condition_ignore_terra_cache for .terraform/lalala",
			fields: fields{
				paths:    []string{filepath.FromSlash(".terraform/lalala")},
				excludes: nil,
			},
			args: args{
				info:       infoTerraCache,
				extensions: model.Extensions{},
				path:       filepath.FromSlash(".terraform/lalala"),
			},
			want: want{
				got: true,
				err: filepath.SkipDir,
			},
		},
		{
			name: "check_condition_ignore_terra_cache for /.terra",
			fields: fields{
				paths:    []string{filepath.FromSlash("/.terra")},
				excludes: nil,
			},
			args: args{
				info:       infoTerraCache,
				extensions: model.Extensions{},
				path:       filepath.FromSlash("/.terra"),
			},
			want: want{
				got: true,
				err: filepath.SkipDir,
			},
		},
		{
			name: "check_condition_ignore_terra_cache for /.terraform",
			fields: fields{
				paths:    []string{filepath.FromSlash("/.terraform")},
				excludes: nil,
			},
			args: args{
				info:       infoTerraCache,
				extensions: model.Extensions{},
				path:       filepath.FromSlash("/.terraform"),
			},
			want: want{
				got: true,
				err: filepath.SkipDir,
			},
		},
		{
			name: "check_condition_ignore_terragrunt_cache for /.terragrunt-cache",
			fields: fields{
				paths:    []string{filepath.FromSlash("/.terragrunt-cache")},
				excludes: nil,
			},
			args: args{
				info:       infoTerraCache,
				extensions: model.Extensions{},
				path:       filepath.FromSlash("/.terragrunt-cache"),
			},
			want: want{
				got: true,
				err: filepath.SkipDir,
			},
		},
		{
			name: "check_condition_ignore_terra_cache for /.terra/lalala",
			fields: fields{
				paths:    []string{filepath.FromSlash("/.terra/lalala")},
				excludes: nil,
			},
			args: args{
				info:       infoTerraCache,
				extensions: model.Extensions{},
				path:       filepath.FromSlash("/.terra/lalala"),
			},
			want: want{
				got: true,
				err: filepath.SkipDir,
			},
		},
		{
			name: "check_condition_ignore_terragrunt_cache for /.terragrunt-cache/lalala",
			fields: fields{
				paths:    []string{filepath.FromSlash("/.terragrunt-cache/lalala")},
				excludes: nil,
			},
			args: args{
				info:       infoTerraCache,
				extensions: model.Extensions{},
				path:       filepath.FromSlash("/.terragrunt-cache/lalala"),
			},
			want: want{
				got: true,
				err: filepath.SkipDir,
			},
		},
		{
			name: "check_condition_ignore_terra_cache for /.terraform/lalala",
			fields: fields{
				paths:    []string{filepath.FromSlash("/.terraform/lalala")},
				excludes: nil,
			},
			args: args{
				info:       infoTerraCache,
				extensions: model.Extensions{},
				path:       filepath.FromSlash("/.terraform/lalala"),
			},
			want: want{
				got: true,
				err: filepath.SkipDir,
			},
		},
		{
			name: "should_skip_terra_cache_folder",
			fields: fields{
				paths:    []string{filepath.FromSlash("test/fixtures/test_terra_cache/.terraform")},
				excludes: nil,
			},
			args: args{
				info:       infoTerraCacheFolder,
				extensions: model.Extensions{},
				path:       filepath.FromSlash("test/fixtures/test_terra_cache/.terraform"),
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
				paths:    tt.fields.paths,
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
	fsystem, err := initFs([]string{filepath.FromSlash("test")}, []string{})
	if err != nil {
		t.Errorf("failed to initialize a new File System Source Provider")
	}
	type fields struct {
		fs *FileSystemSourceProvider
	}
	type args struct {
		excludePaths []string
	}
	tests := []struct {
		name    string
		fields  fields
		args    args
		want    []string
		wantErr bool
	}{
		{
			name: "test_too_many_levels_of_symbolic_links",
			fields: fields{
				fs: fsystem,
			},
			args: args{
				excludePaths: []string{
					"test/fixtures/link_test/eloop_link",
				},
			},
			want:    []string{},
			wantErr: false,
		},
		{
			name: "test_add_excluded",
			fields: fields{
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
			err := tt.fields.fs.AddExcluded(tt.args.excludePaths)
			if (err != nil) != tt.wantErr {
				t.Errorf("AddExcluded() = %v, wantErr = %v", err, tt.wantErr)
			}
			got := getFSExcludes(tt.fields.fs)
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
func initFs(paths, excluded []string) (*FileSystemSourceProvider, error) {
	return NewFileSystemSourceProvider(paths, excluded)
}

func getFSExcludes(fsystem *FileSystemSourceProvider) []string {
	excluded := make([]string, 0)
	for key := range fsystem.excludes {
		excluded = append(excluded, key)
	}
	return excluded
}

func TestProvider_getExcludePaths(t *testing.T) {
	type args struct {
		pathExpressions string
	}
	tests := []struct {
		name    string
		args    args
		want    []string
		wantErr bool
	}{
		{
			name: "test_getExcludedPaths",
			args: args{
				pathExpressions: "*.sh",
			},
			want:    []string(nil),
			wantErr: false,
		},
		{
			name: "test_getExcludedPaths with double start",
			args: args{
				pathExpressions: filepath.Join("test", "fixtures", "analyzer_test", "**", "*.json"),
			},
			want: []string{
				filepath.Join("test", "fixtures", "analyzer_test", "azureResourceManager.json"),
				filepath.Join("test", "fixtures", "analyzer_test", "not_openapi.json"),
				filepath.Join("test", "fixtures", "analyzer_test", "openAPI.json"),
				filepath.Join("test", "fixtures", "analyzer_test", "openAPI_test", "openAPI.json"),
			},
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := GetExcludePaths(tt.args.pathExpressions)
			if (err != nil) != tt.wantErr {
				t.Errorf("getExcludePaths Error: %v, wantErr: %v", got, tt.wantErr)
			}
			require.Equal(t, tt.want, got)
		})
	}
}
