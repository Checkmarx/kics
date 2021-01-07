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
				Name: "resource",
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
				Name: "resource",
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

func TestResultName(t *testing.T) {
	values := []struct {
		rules          build.Rule
		expectedResult Block
		result         Block
	}{
		{
			result: Block{},
			expectedResult: Block{
				Name: "resource",
				All:  false,
				List: nil,
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
		t.Run(fmt.Sprintf("resultName_%d", idx), func(t *testing.T) {
			resultTest := resultName(value.rules, value.result)
			require.Equal(t, value.expectedResult, resultTest)
		})
	}
}

func TestSwitchFunction(t *testing.T) {
	values := []struct {
		v                interface{}
		result           Block
		resources        map[string]struct{}
		expectedResult   Block
		expectedResource map[string]struct{}
	}{
		{
			result: Block{
				Name: "resource",
				All:  false,
				List: nil,
			},
			resources: map[string]struct{}{},
			v:         "*",
			expectedResult: Block{
				Name: "resource",
				All:  true,
				List: nil,
			},
			expectedResource: map[string]struct{}{
				"*": {},
			},
		},
	}
	for idx, value := range values {
		t.Run(fmt.Sprintf("switchFunction_%d", idx), func(t *testing.T) {
			resourcesTest, resultTest := switchFunction(value.v, value.result, value.resources)
			require.Equal(t, value.expectedResult, resultTest)
			require.Equal(t, value.expectedResource, resourcesTest)
		})
	}
}
