package engine

import (
	"reflect"
	"testing"

	build "github.com/Checkmarx/kics/v2/pkg/builder/model"
	"github.com/hashicorp/hcl/v2/hclsyntax"
)

// TestRun tests the functions [Run()] and all the methods called by them
func TestRun(t *testing.T) {
	type args struct {
		src      []byte
		filename string
	}
	tests := []struct {
		name    string
		args    args
		want    []build.Rule
		wantErr bool
	}{
		{
			name: "engine_run",
			args: args{
				src: []byte(`
				//some message in commit
				resource "aws_s3_bucket" "b_website" {
				  bucket = "my-tf-test-bucket"
				  acl = "website"

				  values = {
				    Name = "My bucket"
				    Environment = "Dev"//IncorrectValue:"resource=*,any_key"
				  }

				  versioning {
				    enabled = true
				  }
				}
				`),
				filename: "example.tf",
			},
			want: []build.Rule{
				{
					Conditions: []build.Condition{
						{
							Line:      9,
							IssueType: "IncorrectValue",
							Path: []build.PathItem{
								{
									Name: "resource",
									Type: "RESOURCE",
								},
								{
									Name: "aws_s3_bucket",
									Type: "RESOURCE_TYPE",
								},
								{
									Name: "resource",
									Type: "RESOURCE_NAME",
								},
								{
									Name: "values",
									Type: "DEFAULT",
								},
								{
									Name: "Environment",
									Type: "DEFAULT",
								},
							},
							Attributes: map[string]interface{}{
								"resource": "*",
								"any_key":  nil,
							},
						},
					},
				},
			},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := Run(tt.args.src, tt.args.filename)
			if (err != nil) != tt.wantErr {
				t.Errorf("Run() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			tt.want[0].Conditions[0].Value = got[0].Conditions[0].Value
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("Run() = %v, want %v", got, tt.want)
			}
		})
	}
}

// TestEngine_BuildString tests the functions [buildString()] and all the methods called by them
func TestEngine_BuildString(t *testing.T) {
	type args struct {
		parts []hclsyntax.Expression
	}
	type fields struct {
		Engine *Engine
	}
	tests := []struct {
		name    string
		args    args
		fields  fields
		want    string
		wantErr bool
	}{
		{
			name: "build_string",
			fields: fields{
				Engine: &Engine{},
			},
			args: args{
				parts: []hclsyntax.Expression{},
			},
			want:    "",
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := tt.fields.Engine.buildString(tt.args.parts)
			if (err != nil) != tt.wantErr {
				t.Errorf("Run() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("Run() = %v, want %v", got, tt.want)
			}
		})
	}
}
