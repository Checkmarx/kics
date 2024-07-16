package buildah

import (
	"encoding/json"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/stretchr/testify/require"
)

// TestParser_Parse tests the parsing of a Buildah file.
func TestParser_Parse(t *testing.T) {
	type args struct {
		in0         string
		fileContent []byte
	}
	tests := []struct {
		name    string
		p       *Parser
		args    args
		want    string
		want1   []int
		wantErr bool
	}{
		{
			name: "Buildah simple parse",
			p:    &Parser{},
			args: args{
				in0: "test.sh",
				fileContent: []byte(`
				ctr=$(buildah from fedora)
				buildah config --env GOPATH=/root/buildah $ctr
				`),
			},
			want: `[
				{
					"command": {
						"fedora": [
							{
								"Cmd": "buildah from",
								"EndLine": 2,
								"Original": "buildah from fedora",
								"Value": "fedora",
								"_kics_line": 2
							},
							{
								"Cmd": "buildah config",
								"EndLine": 3,
								"Original": "buildah config --env GOPATH=/root/buildah $ctr",
								"Value": "--env GOPATH=/root/buildah $ctr",
								"_kics_line": 3
							}
						]
					}
				}
			]`,
			want1:   []int(nil),
			wantErr: false,
		}, {
			name: "Buildah with normal comments parse",
			p:    &Parser{},
			args: args{
				in0: "test.sh",
				fileContent: []byte(`#
				ctr=$(buildah from fedora)
				# buildah config --env GOPATH=/root/buildah $ctr
				buildah commit $ctr buildahupstream
				# buildah run "$ctr" mkdir /tmp/open
				`),
			},
			want: `[
				{
					"command": {
						"fedora": [
							{
								"Cmd": "buildah from",
								"EndLine": 2,
								"Original": "buildah from fedora",
								"Value": "fedora",
								"_kics_line": 2
							},
							{
								"Cmd": "buildah commit",
								"EndLine": 4,
								"Original": "buildah commit $ctr buildahupstream",
								"Value": "$ctr buildahupstream",
								"_kics_line": 4
							}
						]
					}
				}
			]`,
			want1:   []int{1, 3, 5},
			wantErr: false,
		},
		{
			name: "Buildah with normal comments + kics-scan ignore-line parse",
			p:    &Parser{},
			args: args{
				in0: "test.sh",
				fileContent: []byte(`#
				ctr=$(buildah from fedora)
				# kics-scan ignore-line
				buildah config --env GOPATH=/root/buildah $ctr
				buildah commit $ctr buildahupstream
				# buildah run "$ctr" mkdir /tmp/open
				`),
			},
			want: `[
				{
					"command": {
						"fedora": [
							{
								"Cmd": "buildah from",
								"EndLine": 2,
								"Original": "buildah from fedora",
								"Value": "fedora",
								"_kics_line": 2
							},
							{
								"Cmd": "buildah config",
								"EndLine": 4,
								"Original": "buildah config --env GOPATH=/root/buildah $ctr",
								"Value": "--env GOPATH=/root/buildah $ctr",
								"_kics_line": 4
							},
							{
								"Cmd": "buildah commit",
								"EndLine": 5,
								"Original": "buildah commit $ctr buildahupstream",
								"Value": "$ctr buildahupstream",
								"_kics_line": 5
							}
						]
					}
				}
			]`,
			want1:   []int{1, 3, 4, 6},
			wantErr: false,
		},
		{
			name: "Buildah with kics-scan ignore-block related to from parse",
			p:    &Parser{},
			args: args{
				in0: "test.sh",
				fileContent: []byte(`#
				# kics-scan ignore-block
				ctr=$(buildah from fedora)
				buildah run ${ctr} git clone https://github.com/Checkmarx/kics.git
				ctr2=$(buildah from fedora2)
				buildah run ${ctr2} git clone https://github.com/Checkmarx/kics.git
				`),
			},
			want: `[
				{
					"command": {
						"fedora": [
							{
								"Cmd": "buildah from",
								"EndLine": 3,
								"Original": "buildah from fedora",
								"Value": "fedora",
								"_kics_line": 3
							},
							{
								"Cmd": "buildah run",
								"EndLine": 4,
								"Original": "buildah run ${ctr} git clone https://github.com/Checkmarx/kics.git",
								"Value": "${ctr} git clone https://github.com/Checkmarx/kics.git",
								"_kics_line": 4
							}
						],
						"fedora2": [
							{
								"Cmd": "buildah from",
								"EndLine": 5,
								"Original": "buildah from fedora2",
								"Value": "fedora2",
								"_kics_line": 5
							},
							{
								"Cmd": "buildah run",
								"EndLine": 6,
								"Original": "buildah run ${ctr2} git clone https://github.com/Checkmarx/kics.git",
								"Value": "${ctr2} git clone https://github.com/Checkmarx/kics.git",
								"_kics_line": 6
							}
						]
					}
				}
			]`,
			want1:   []int{1, 2, 3, 4},
			wantErr: false,
		}, {
			name: "Buildah with kics-scan ignore-block related to command parse",
			p:    &Parser{},
			args: args{
				in0: "test.sh",
				fileContent: []byte(`#
				ctr=$(buildah from fedora)
				# kics-scan ignore-block
				buildah run $ctr /bin/sh -c 'git clone https://github.com/Checkmarx/kics.git; \
								make'
				`),
			},
			want: `[
				{
					"command": {
						"fedora": [
							{
								"Cmd": "buildah from",
								"EndLine": 2,
								"Original": "buildah from fedora",
								"Value": "fedora",
								"_kics_line": 2
							},
							{
								"Cmd": "buildah run",
								"EndLine": 5,
								"Original": "buildah run $ctr /bin/sh -c 'git clone https://github.com/Checkmarx/kics.git; make'",
								"Value": "$ctr /bin/sh -c 'git clone https://github.com/Checkmarx/kics.git; make'",
								"_kics_line": 4
							}
						]
					}
				}
			]`,
			want1:   []int{1, 3, 4, 5},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			p := &Parser{}
			got, got1, err := p.Parse(tt.args.in0, tt.args.fileContent)
			if (err != nil) != tt.wantErr {
				t.Errorf("Parser.Parse() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			gotString, err := json.Marshal(got)
			require.NoError(t, err)
			require.JSONEq(t, tt.want, string(gotString))
			if !reflect.DeepEqual(got1, tt.want1) {
				t.Errorf("Parser.Parse() got1 = %v, want %v", got1, tt.want1)
			}
		})
	}
}

// TestParser_SupportedExtensions tests the SupportedExtensions function
func TestParser_SupportedExtensions(t *testing.T) {
	tests := []struct {
		name string
		p    *Parser
		want []string
	}{
		{
			name: "Buildah extensions",
			p:    &Parser{},
			want: []string{".sh"},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			p := &Parser{}
			if got := p.SupportedExtensions(); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("Parser.SupportedExtensions() = %v, want %v", got, tt.want)
			}
		})
	}
}

// TestParser_SupportedTypes tests the SupportedTypes function
func TestParser_SupportedTypes(t *testing.T) {
	tests := []struct {
		name string
		p    *Parser
		want map[string]bool
	}{
		{
			name: "Buildah types",
			p:    &Parser{},
			want: map[string]bool{"buildah": true},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			p := &Parser{}
			if got := p.SupportedTypes(); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("Parser.SupportedTypes() = %v, want %v", got, tt.want)
			}
		})
	}
}

// TestParser_Resolve tests the Resolve function
func TestParser_Resolve(t *testing.T) {
	type args struct {
		fileContent []byte
		filename    string
	}
	tests := []struct {
		name    string
		p       *Parser
		args    args
		want    []byte
		wantErr bool
	}{
		{
			name: "Buildah resolve",
			p:    &Parser{},
			args: args{
				fileContent: []byte(``),
				filename:    "test.proto",
			},
			want: []byte{},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			p := &Parser{}
			got, err := p.Resolve(tt.args.fileContent, tt.args.filename, true, 15)
			if (err != nil) != tt.wantErr {
				t.Errorf("Parser.Resolve() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("Parser.Resolve() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestParser_GetResolvedFiles(t *testing.T) {
	tests := []struct {
		name string
		want map[string]model.ResolvedFile
	}{
		{
			name: "Buildah get resolved files",
			want: map[string]model.ResolvedFile{},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			p := &Parser{}
			if got := p.GetResolvedFiles(); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("GetResolvedFiles() = %v, want %v", got, tt.want)
			}
		})
	}
}
