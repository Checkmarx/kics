package writer

import (
	"fmt"
	"testing"

	build "github.com/Checkmarx/kics/pkg/builder/model"
	"github.com/stretchr/testify/require"
)

func TestConditionKey(t *testing.T) {
	values := []struct {
		block           Block
		c               build.Condition
		withBlockPrefix bool
		pathOnly        bool
		expectedResult  string
	}{
		{
			block: Block{
				Name: "",
				All:  true,
				List: []string{"*"},
			},
			c: build.Condition{
				Line:      8,
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
				Value: "Dev",
				Attributes: map[string]interface{}{
					"resource": "*",
					"any_key":  "",
				},
			},
			withBlockPrefix: false,
			pathOnly:        true,
			expectedResult:  "block[blockType][name].values[key]",
		},
	}
	for idx, value := range values {
		t.Run(fmt.Sprintf("conditionKey_%d", idx), func(t *testing.T) {
			key := conditionKey(value.block, value.c, value.pathOnly, value.withBlockPrefix)
			require.Equal(t, value.expectedResult, key)
		})
	}
}

func TestCreateBlock(t *testing.T) {
	values := []struct {
		rules          build.Rule
		expectedResult Block
	}{
		{
			expectedResult: Block{
				Name: "",
				All:  true,
				List: []string{"*"},
			},
			rules: build.Rule{
				Conditions: []build.Condition{
					{
						Line:      8,
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
						Value: "Dev",
						Attributes: map[string]interface{}{
							"resource": "*",
							"any_key":  "",
						},
					},
				},
			},
		},
	}
	for idx, value := range values {
		t.Run(fmt.Sprintf("createBlock_%d", idx), func(t *testing.T) {
			result := createBlock(value.rules)
			require.Equal(t, value.expectedResult, result)
		})
	}
}
