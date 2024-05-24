package writer

import (
	"fmt"
	"os"
	"strings"
	"testing"

	build "github.com/Checkmarx/kics/v2/pkg/builder/model"
	"github.com/stretchr/testify/require"
)

var blockElement = Block{
	Name: "resource",
	All:  true,
	List: []string{"*"},
}

var pathElement = []build.PathItem{
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
}

var ruleElement = build.Rule{
	Conditions: []build.Condition{
		{
			Line:      8,
			IssueType: "IncorrectValue",
			Path:      pathElement,
			Value:     "Dev",
			Attributes: map[string]interface{}{
				"resource": "*",
				"any_key":  "",
			},
		},
	},
}

// TestConditionKey tests the functions [conditionKey()] and all the methods called by them
func TestConditionKey(t *testing.T) {
	values := []struct {
		block           Block
		c               build.Condition
		withBlockPrefix bool
		pathOnly        bool
		expectedResult  string
	}{
		{
			block: blockElement,
			c: build.Condition{
				Line:      8,
				IssueType: "IncorrectValue",
				Path:      pathElement,
				Value:     "Dev",
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

// TestCreateBlock tests the functions [createBlock()] and all the methods called by them
func TestCreateBlock(t *testing.T) {
	values := []struct {
		rules          build.Rule
		expectedResult Block
	}{
		{
			expectedResult: blockElement,
			rules:          ruleElement,
		},
	}
	for idx, value := range values {
		t.Run(fmt.Sprintf("createBlock_%d", idx), func(t *testing.T) {
			result := createBlock(value.rules)
			require.Equal(t, value.expectedResult, result)
		})
	}
}

// TestResultName tests the functions [resultName()] and all the methods called by them
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
			rules: ruleElement,
		},
	}
	for idx, value := range values {
		t.Run(fmt.Sprintf("resultName_%d", idx), func(t *testing.T) {
			resultTest := resultName(value.rules, value.result)
			require.Equal(t, value.expectedResult, resultTest)
		})
	}
}

// TestSwitchFunction tests the functions [switchFunction()] and all the methods called by them
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
		{
			result: Block{
				Name: "resource",
				All:  false,
				List: nil,
			},
			resources: map[string]struct{}{},
			v:         []string{"first", "second"},
			expectedResult: Block{
				Name: "resource",
				All:  false,
				List: nil,
			},
			expectedResource: map[string]struct{}{
				"first":  {},
				"second": {},
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

// TestRegoValueToString tests the functions [regoValueToString()] and all the methods called by them
func TestRegoValueToString(t *testing.T) {
	var emptyStringPointer *string
	var strPointer = new(string)
	*strPointer = "testString"

	values := []struct {
		testCase       interface{}
		expectedResult string
	}{
		{
			testCase:       true,
			expectedResult: "true",
		},
		{
			testCase:       false,
			expectedResult: "false",
		},
		{
			testCase:       int64(9223372036854775806),
			expectedResult: "9223372036854775806",
		},
		{
			testCase:       int32(2147483647),
			expectedResult: "2147483647",
		},
		{
			testCase:       float64(123456.5),
			expectedResult: "123456.500000",
		},
		{
			testCase:       float32(123.5),
			expectedResult: "123.500000",
		},
		{
			testCase:       0,
			expectedResult: "0",
		},
		{
			testCase:       "string",
			expectedResult: "\"string\"",
		},
		{
			testCase:       emptyStringPointer,
			expectedResult: "\"\"",
		},
		{
			testCase:       strPointer,
			expectedResult: "\"testString\"",
		},
		{
			testCase:       []string{"a", "b", "c"},
			expectedResult: "{\"a\", \"b\", \"c\"}",
		},
		{
			testCase:       []int{1, 2, 3},
			expectedResult: "",
		},
	}

	for idx, value := range values {
		t.Run(fmt.Sprintf("regoValueToString_%d", idx), func(t *testing.T) {
			result := regoValueToString(value.testCase)
			require.Equal(t, value.expectedResult, result)
		})
	}
}

// TestCondition tests the functions [condition()] and all the methods called by them
func TestCondition(t *testing.T) {
	values := []struct {
		block          Block
		c              build.Condition
		expectedResult string
	}{
		{
			block: blockElement,
			c: build.Condition{
				Line:      8,
				IssueType: "IncorrectValue",
				Path:      pathElement,
				Value:     "DEV",
				Attributes: map[string]interface{}{
					"resource": "*",
					"any_key":  "",
					"upper":    "",
				},
			},
			expectedResult: "upper(block[blockType][name].values[key]) == \"DEV\"",
		},
		{
			block: blockElement,
			c: build.Condition{
				Line:      8,
				IssueType: "IncorrectValue",
				Path:      pathElement,
				Attributes: map[string]interface{}{
					"resource":  "*",
					"any_key":   "",
					"lower":     "",
					"condition": "!=",
					"val":       "dev",
				},
			},
			expectedResult: "lower(block[blockType][name].values[key]) != \"dev\"",
		},
		{
			block: blockElement,
			c: build.Condition{
				Line:      8,
				IssueType: "IncorrectValue",
				Path:      pathElement,
				Value:     "dev",
				Attributes: map[string]interface{}{
					"resource": "*",
					"any_key":  "",
					"regex":    "\\w",
				},
			},
			expectedResult: fmt.Sprintf("re_match(%q, block[blockType][name].values[key])", "\\w"),
		},
		{
			block: blockElement,
			c: build.Condition{
				Line:      8,
				IssueType: "MissingAttribute",
				Path:      pathElement,
				Attributes: map[string]interface{}{
					"resource": "*",
					"any_key":  "",
				},
			},
			expectedResult: "not block[blockType][name].values[key]",
		},
		{
			block: blockElement,
			c: build.Condition{
				Line:      8,
				IssueType: "RedundantAttribute",
				Path:      pathElement,
				Attributes: map[string]interface{}{
					"resource": "*",
					"any_key":  "",
				},
			},
			expectedResult: "block[blockType][name].values[key]",
		},
	}
	for idx, value := range values {
		t.Run(fmt.Sprintf("condition_%d", idx), func(t *testing.T) {
			key := condition(value.block, value.c)
			require.Equal(t, value.expectedResult, key)
		})
	}
}

// TestFormat tests the functions [format()] and all the methods called by them
func TestFormat(t *testing.T) {
	values := []struct {
		rule           build.Rule
		expectedResult RegoRule
	}{
		{
			rule: ruleElement,
			expectedResult: RegoRule{
				Block: blockElement,
				Rule:  ruleElement,
			},
		},
	}
	for idx, value := range values {
		t.Run(fmt.Sprintf("format_%d", idx), func(t *testing.T) {
			result := format([]build.Rule{ruleElement})
			require.Equal(t, []RegoRule{value.expectedResult}, result)
		})
	}
}

// TestRender tests the functions [Render()] and all the methods called by them
func TestRender(t *testing.T) {
	for currentDir, err := os.Getwd(); getCurrentDirName(currentDir) != "kics"; currentDir, err = os.Getwd() {
		if err == nil {
			if dirErr := os.Chdir(".."); dirErr != nil { // this is necessary to load template file on RegoWriter
				t.Fatal(dirErr)
			}
		} else {
			t.Fatal(err)
		}
	}
	regoWriter, err := NewRegoWriter()
	if err != nil {
		t.Fatal(err)
	}
	values := []struct {
		rules          []build.Rule
		expectedResult string
	}{
		{
			rules: []build.Rule{ruleElement},
			expectedResult: `package Cx

			CxPolicy [ result ] {
					document := input.document[i]
					block := document.resource

					block[blockType][name].values[key] == "Dev"

					result := {
											"documentId":           document.id,
											"searchKey":        sprintf("%s[%s].values.%s", [blockType, name, key]),
											"issueType":            "IncorrectValue",
											"keyExpectedValue": "'values' should be valid",
											"keyActualValue":       "'values' is invalid"
										}
			}`,
		},
	}
	for idx, value := range values {
		t.Run(fmt.Sprintf("format_%d", idx), func(t *testing.T) {
			results, err := regoWriter.Render(value.rules)
			require.NoError(t, err)
			require.Equal(t, removeWhiteSpaces(string(results)), removeWhiteSpaces(value.expectedResult))
		})
	}
}

func getCurrentDirName(path string) string {
	dirs := strings.Split(path, string(os.PathSeparator))
	if dirs[len(dirs)-1] == "" && len(dirs) > 1 {
		return dirs[len(dirs)-2]
	}
	return dirs[len(dirs)-1]
}

func removeWhiteSpaces(str string) string {
	str = strings.TrimSpace(str)
	whitespaces := []string{"\r\n", "\n", " ", "\t"}
	for _, removeSpaceChar := range whitespaces {
		str = strings.ReplaceAll(str, removeSpaceChar, "")
	}
	return str
}
