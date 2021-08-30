package flags

import (
	"fmt"
	"strings"
	"testing"

	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/pkg/engine/source"
	"github.com/stretchr/testify/require"
)

func TestFlags_GetStrFlag(t *testing.T) {
	tests := []struct {
		name     string
		flagName string
		expected string
	}{
		{
			name:     "should return value for valid flag",
			flagName: "test",
			expected: "exists",
		},
		{
			name:     "should not return value for invalid flag",
			flagName: "undefined",
			expected: "",
		},
	}
	existValue := "exists"
	flagsStrReferences["test"] = &existValue
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got := GetStrFlag(test.flagName)
			require.Equal(t, test.expected, got)
		})
	}
}

func TestFlags_GetMultiStrFlag(t *testing.T) {
	tests := []struct {
		name     string
		flagName string
		expected []string
	}{
		{
			name:     "should return value for valid flag",
			flagName: "test",
			expected: []string{"exists"},
		},
		{
			name:     "should not return value for invalid flag",
			flagName: "undefined",
			expected: []string{},
		},
	}
	existValue := []string{"exists"}
	flagsMultiStrReferences["test"] = &existValue
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got := GetMultiStrFlag(test.flagName)
			require.Len(t, test.expected, len(got))
			require.Equal(t, test.expected, got)
		})
	}
}

func TestFlags_GetBoolFlag(t *testing.T) {
	tests := []struct {
		name     string
		flagName string
		expected bool
	}{
		{
			name:     "should return value for valid flag",
			flagName: "test",
			expected: true,
		},
		{
			name:     "should not return value for invalid flag",
			flagName: "undefined",
			expected: false,
		},
	}
	existValue := true
	flagsBoolReferences["test"] = &existValue
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got := GetBoolFlag(test.flagName)
			require.Equal(t, test.expected, got)
		})
	}
}

func TestFlags_GetIntFlag(t *testing.T) {
	tests := []struct {
		name     string
		flagName string
		expected int
	}{
		{
			name:     "should return value for valid flag",
			flagName: "test",
			expected: 1,
		},
		{
			name:     "should not return value for invalid flag",
			flagName: "undefined",
			expected: -1,
		},
	}
	existValue := 1
	flagsIntReferences["test"] = &existValue
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got := GetIntFlag(test.flagName)
			require.Equal(t, test.expected, got)
		})
	}
}

func TestFlags_SetStrFlag(t *testing.T) {
	tests := []struct {
		name     string
		flagName string
		expected string
	}{
		{
			name:     "should return value for valid flag",
			flagName: "test",
			expected: "exists",
		},
		{
			name:     "should not return value for invalid flag",
			flagName: "undefined",
			expected: "",
		},
	}
	existValue := "test"
	flagsStrReferences["test"] = &existValue
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			SetStrFlag(test.flagName, "exists")
			got := GetStrFlag(test.flagName)
			require.Equal(t, test.expected, got)
		})
	}
}

func TestFlags_SetMultiStrFlag(t *testing.T) {
	tests := []struct {
		name     string
		flagName string
		expected []string
	}{
		{
			name:     "should return value for valid flag",
			flagName: "test",
			expected: []string{"exists"},
		},
		{
			name:     "should not return value for invalid flag",
			flagName: "undefined",
			expected: []string{},
		},
	}
	existValue := []string{"test"}
	flagsMultiStrReferences["test"] = &existValue
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			SetMultiStrFlag(test.flagName, []string{"exists"})
			got := GetMultiStrFlag(test.flagName)
			require.Len(t, test.expected, len(got))
			require.Equal(t, test.expected, got)
		})
	}
}

func TestFlags_evalUsage(t *testing.T) {
	tests := []struct {
		name     string
		usage    string
		expected string
	}{
		{
			name:     "should return same text",
			usage:    "test",
			expected: "test",
		},
		{
			name:     "should return message translated",
			usage:    "test ${supportedPlatforms}",
			expected: fmt.Sprintf("test %s", strings.Join(source.ListSupportedPlatforms(), ", ")),
		},
		{
			name:     "should return message translated for multiple variables",
			usage:    "test ${supportedPlatforms} ${defaultLogFile}",
			expected: fmt.Sprintf("test %s %s", strings.Join(source.ListSupportedPlatforms(), ", "), constants.DefaultLogFile),
		},
	}
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got := evalUsage(test.usage)
			require.Equal(t, test.expected, got)
		})
	}
}
