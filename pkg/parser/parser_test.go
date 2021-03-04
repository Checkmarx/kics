package parser

import (
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	dockerParser "github.com/Checkmarx/kics/pkg/parser/docker"
	jsonParser "github.com/Checkmarx/kics/pkg/parser/json"
	terraformParser "github.com/Checkmarx/kics/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/pkg/parser/yaml"
	"github.com/stretchr/testify/require"
)

// TestParser_Parse tests the functions [Parse()] and all the methods called by them
func TestParser_Parse(t *testing.T) {
	p := initilizeBuilder()

	docs, kind, err := p.Parse("test.json", []byte(`
{
	"martin": {
		"name": "Martin D'vloper"
	}
}
`))
	require.NoError(t, err)
	require.Len(t, docs, 1)
	require.Contains(t, docs[0], "martin")
	require.Equal(t, model.KindJSON, kind)

	docs, kind, err = p.Parse("test.yaml", []byte(`
martin:
  name: Martin D'vloper
`))
	require.NoError(t, err)
	require.Len(t, docs, 1)
	require.Contains(t, docs[0], "martin")
	require.Equal(t, model.KindYAML, kind)

	docs, kind, err = p.Parse("Dockerfile", []byte(`
	FROM foo
	COPY . /
	RUN echo hello
`))

	require.NoError(t, err)
	require.Len(t, docs, 1)
	require.Equal(t, model.KindDOCKER, kind)
}

// TestParser_Empty tests the functions [Parse()] and all the methods called by them (tests an empty parser)
func TestParser_Empty(t *testing.T) {
	p, err := NewBuilder().
		Build([]string{""})
	if err != nil {
		t.Errorf("Error building parser: %s", err)
	}
	doc, kind, err := p.Parse("test.json", nil)
	require.Nil(t, doc)
	require.Equal(t, model.FileKind(""), kind)
	require.Error(t, err)
	require.Equal(t, ErrNotSupportedFile, err)
}

// TestParser_SupportedExtensions tests the functions [SupportedExtensions()] and all the methods called by them
func TestParser_SupportedExtensions(t *testing.T) {
	p := initilizeBuilder()

	extensions := p.SupportedExtensions()
	require.NotNil(t, extensions)
	require.Contains(t, extensions, ".json")
	require.Contains(t, extensions, ".tf")
	require.Contains(t, extensions, ".yaml")
	require.Contains(t, extensions, ".dockerfile")
	require.Contains(t, extensions, "Dockerfile")
}

func initilizeBuilder() *Parser {
	bd, _ := NewBuilder().
		Add(&jsonParser.Parser{}).
		Add(&yamlParser.Parser{}).
		Add(terraformParser.NewDefault()).
		Add(&dockerParser.Parser{}).
		Build([]string{""})
	return bd
}

// TestParser_SupportedExtensions tests the functions [validateArguments()] and all the methods called by them
func TestValidateArguments(t *testing.T) {
	type args struct {
		types     []string
		validArgs []string
	}
	tests := []struct {
		name    string
		args    args
		wantErr bool
	}{
		{
			name: "validate_args_error",
			args: args{
				types:     []string{"dockerfiles"},
				validArgs: []string{"Dockerfile", "Ansible", "Terraform", "CloudFormation", "Kubernetes"},
			},
			wantErr: true,
		},
		{
			name: "validate_args",
			args: args{
				types:     []string{"Dockerfile"},
				validArgs: []string{"Dockerfile", "Ansible", "Terraform", "CloudFormation", "Kubernetes"},
			},
			wantErr: false,
		},
		{
			name: "validate_args_case_sensetive",
			args: args{
				types:     []string{"kubernetes"},
				validArgs: []string{"Dockerfile", "Ansible", "Terraform", "CloudFormation", "Kubernetes"},
			},
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := validateArguments(tt.args.types, tt.args.validArgs)
			if (err != nil) != tt.wantErr {
				t.Errorf("validateArguments() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
		})
	}
}

func TestRemoveDuplicateValues(t *testing.T) {
	type args struct {
		stringSlice []string
	}
	tests := []struct {
		name string
		args args
		want []string
	}{
		{
			name: "remove_duplications",
			args: args{
				stringSlice: []string{
					"test",
					"test1",
					"test",
					"test2",
				},
			},
			want: []string{
				"test",
				"test1",
				"test2",
			},
		},
		{
			name: "no_duplicates",
			args: args{
				stringSlice: []string{
					"test",
					"test1",
					"test2",
				},
			},
			want: []string{
				"test",
				"test1",
				"test2",
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := removeDuplicateValues(tt.args.stringSlice)
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("removeDuplicateValues() = %v, want %v", got, tt.want)
			}
		})
	}
}
