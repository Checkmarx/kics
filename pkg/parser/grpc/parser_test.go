package grpc

import (
	"encoding/json"
	"fmt"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/stretchr/testify/require"
)

// TestParser_Parse tests the parsing of a grpc file.
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
			name: "grpc simple parse",
			p:    &Parser{},
			args: args{
				in0: "test.proto",
				fileContent: []byte(`
				syntax = "proto3";
				`),
			},
			want: `[
				{
					"enum": {},
					"services": {},
					"imports": {},
					"options": [],
					"syntax": "proto3",
					"package": "",
					"messages": {}
				}
			]`,
			want1:   []int{},
			wantErr: false,
		},
		{
			name: "grpc complex file",
			p:    &Parser{},
			args: args{
				in0: "test.proto",
				fileContent: []byte(`syntax = "proto3";
				package Cx;
				import public "other.proto";
				option java_package = "com.example.foo";
				enum EnumAllowingAlias {
				  option allow_alias = true;
				  UNKNOWN = 0;
				  STARTED = 1;
				  RUNNING = 2 [(custom_option) = "hello world"];
				}
				message Outer {
				  option (my_option).a = true;
				  message Inner {   // Level 2
					int64 ival = 1;
				  }
				  repeated Inner inner_message = 2;
				  EnumAllowingAlias enum_field =3;
				  map<int32, string> my_map = 4;
				}`),
			},
			want: `[
				{
					"imports": {
						"other.proto": {
							"kind": "public"
						}
					},
					"options": [
						{
							"constant": {
								"isString": true,
								"quoteRune": 34,
								"source": "com.example.foo"
							},
							"name": "java_package"
						}
					],
					"syntax": "proto3",
					"package": "Cx",
					"messages": {
						"Outer": {
							"field": {
								"enum_field": {
									"sequence": 3,
									"type": "EnumAllowingAlias"
								},
								"inner_message": {
									"repeated": true,
									"sequence": 2,
									"type": "Inner"
								}
							},
							"inner_message": {
								"Inner": {
									"field": {
										"ival": {
											"sequence": 1,
											"type": "int64"
										}
									}
								}
							},
							"map": {
								"my_map": {
									"field": {
										"sequence": 4,
										"type": "string"
									},
									"key_type": "int32"
								}
							},
							"options": {
								"(my_option).a": {
									"constant": {
										"source": "true"
									},
									"name": "(my_option).a"
								}
							}
						}
					},
					"enum": {
						"EnumAllowingAlias": {
							"field": {
								"RUNNING": {
									"options": {
										"constant": {
											"isString": true,
											"quoteRune": 34,
											"source": "hello world"
										},
										"isEmbedded": true,
										"name": "(custom_option)"
									},
									"value": 2
								},
								"STARTED": {
									"options": {
										"constant": {}
									},
									"value": 1
								},
								"UNKNOWN": {
									"options": {
										"constant": {}
									}
								}
							},
							"options": {
								"allow_alias": {
									"constant": {
										"source": "true"
									},
									"name": "allow_alias"
								}
							}
						}
					},
					"services": {}
				}
			]`,
			want1:   []int{},
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
			fmt.Println(string(gotString))
			require.NoError(t, err)
			fmt.Println(string(gotString))
			require.JSONEq(t, tt.want, string(gotString))
			if !reflect.DeepEqual(got1, tt.want1) {
				t.Errorf("Parser.Parse() got1 = %v, want %v", got1, tt.want1)
			}
		})
	}
}

// TestParser_GetKind tests the GetKind function
func TestParser_GetKind(t *testing.T) {
	tests := []struct {
		name string
		p    *Parser
		want model.FileKind
	}{
		{
			name: "grpc kind",
			p:    &Parser{},
			want: model.KindPROTO,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			p := &Parser{}
			if got := p.GetKind(); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("Parser.GetKind() = %v, want %v", got, tt.want)
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
			name: "grpc extensions",
			p:    &Parser{},
			want: []string{".proto"},
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
		want []string
	}{
		{
			name: "grpc types",
			p:    &Parser{},
			want: []string{"grpc"},
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

// TestParser_GetCommentToken tests the GetCommentToken function
func TestParser_GetCommentToken(t *testing.T) {
	tests := []struct {
		name string
		p    *Parser
		want string
	}{
		{
			name: "grpc comment token",
			p:    &Parser{},
			want: "",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			p := &Parser{}
			if got := p.GetCommentToken(); got != tt.want {
				t.Errorf("Parser.GetCommentToken() = %v, want %v", got, tt.want)
			}
		})
	}
}

// TestParser_StringifyContent tests the StringifyContent function
func TestParser_StringifyContent(t *testing.T) {
	type args struct {
		content []byte
	}
	tests := []struct {
		name    string
		p       *Parser
		args    args
		want    string
		wantErr bool
	}{
		{
			name: "grpc stringify content",
			p:    &Parser{},
			args: args{
				content: []byte(`
syntax = "proto3";
import "google/protobuf/descriptor.proto";`),
			},
			want: `
syntax = "proto3";
import "google/protobuf/descriptor.proto";`,
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			p := &Parser{}
			got, err := p.StringifyContent(tt.args.content)
			if (err != nil) != tt.wantErr {
				t.Errorf("Parser.StringifyContent() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if got != tt.want {
				t.Errorf("Parser.StringifyContent() = %v, want %v", got, tt.want)
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
		want    *[]byte
		wantErr bool
	}{
		{
			name: "grpc resolve",
			p:    &Parser{},
			args: args{
				fileContent: []byte(``),
				filename:    "test.proto",
			},
			want: &[]byte{},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			p := &Parser{}
			got, err := p.Resolve(tt.args.fileContent, tt.args.filename)
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
