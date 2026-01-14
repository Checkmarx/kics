package terraform

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/require"
	"github.com/zclconf/go-cty/cty"

	"github.com/Checkmarx/kics/v2/pkg/parser/terraform/converter"
)

type extractLocalsTest struct {
	name     string
	filename string
	wantKeys []string
	wantErr  bool
}

type buildLocalsTest struct {
	name        string
	currentPath string
	wantKeys    []string
	wantValues  map[string]cty.Value
	wantErr     bool
}

func TestExtractLocalsFromFile(t *testing.T) {
	tests := []extractLocalsTest{
		{
			name:     "Should extract simple locals from file",
			filename: filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_locals", "simple", "simple_locals.tf"),
			wantKeys: []string{"simple_string", "simple_number", "simple_bool"},
			wantErr:  false,
		},
		{
			name:     "Should extract locals referencing variables",
			filename: filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_locals", "with_vars", "locals_with_vars.tf"),
			wantKeys: []string{"resource_prefix", "tag_name"},
			wantErr:  false,
		},
		{
			name:     "Should extract multiple locals blocks from single file",
			filename: filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_locals", "multi_blocks", "multiple_blocks.tf"),
			wantKeys: []string{"first_local", "second_local", "third_local", "combined"},
			wantErr:  false,
		},
		{
			name:     "Should return empty map for file without locals",
			filename: filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_locals", "no_locals", "no_locals.tf"),
			wantKeys: []string{},
			wantErr:  false,
		},
		{
			name:     "Should return error for non-existent file",
			filename: filepath.FromSlash("not_found.tf"),
			wantKeys: nil,
			wantErr:  true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			localsAttrs, err := extractLocalsFromFile(tt.filename)
			if tt.wantErr {
				require.NotNil(t, err)
				require.Nil(t, localsAttrs)
			} else {
				require.NoError(t, err)
				require.Equal(t, len(tt.wantKeys), len(localsAttrs))
				for _, key := range tt.wantKeys {
					_, exists := localsAttrs[key]
					require.True(t, exists, "Expected local '%s' not found", key)
				}
			}
		})
	}
}

func TestBuildLocalsForDirectory(t *testing.T) {
	tests := []buildLocalsTest{
		{
			name:        "Should build locals from directory with simple locals",
			currentPath: filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_locals", "isolated"),
			wantKeys:    []string{"isolated_value"},
			wantValues: map[string]cty.Value{
				"isolated_value": cty.StringVal("isolated"),
			},
			wantErr: false,
		},
		{
			name:        "Should return empty map for directory with no locals",
			currentPath: filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_variables"),
			wantKeys:    []string{},
			wantValues:  map[string]cty.Value{},
			wantErr:     false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			inputVariableMap = make(converter.VariableMap)
			localsMap, err := buildLocalsForDirectory(tt.currentPath)
			if tt.wantErr {
				require.NotNil(t, err)
			} else {
				require.NoError(t, err)
				require.Equal(t, len(tt.wantKeys), len(localsMap))
				for key, expectedValue := range tt.wantValues {
					actualValue, exists := localsMap[key]
					require.True(t, exists, "Expected local '%s' not found", key)
					require.True(t, expectedValue.RawEquals(actualValue), "Value mismatch for local '%s'", key)
				}
			}
		})
	}

	t.Cleanup(func() {
		inputVariableMap = make(converter.VariableMap)
		localsCache = make(map[string]converter.VariableMap)
	})
}

func TestBuildLocalsForDirectory_CrossFileReferences(t *testing.T) {
	t.Run("Should handle locals referencing other locals from different files", func(t *testing.T) {
		inputVariableMap = make(converter.VariableMap)
		currentPath := filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_locals", "cross_file")

		localsMap, err := buildLocalsForDirectory(currentPath)
		require.NoError(t, err)

		// Check that base_name from cross_file_locals_a.tf exists
		baseName, exists := localsMap["base_name"]
		require.True(t, exists, "base_name should exist")
		require.Equal(t, "myapp", baseName.AsString())

		// Check that full_name from cross_file_locals_b.tf references base_name
		fullName, exists := localsMap["full_name"]
		require.True(t, exists, "full_name should exist")
		require.Equal(t, "myapp-service", fullName.AsString())

		// Check that base_port is referenced correctly
		basePort, exists := localsMap["base_port"]
		require.True(t, exists, "base_port should exist")

		fullPort, exists := localsMap["full_port"]
		require.True(t, exists, "full_port should exist")
		require.True(t, basePort.RawEquals(fullPort), "full_port should equal base_port")
	})

	t.Cleanup(func() {
		inputVariableMap = make(converter.VariableMap)
		localsCache = make(map[string]converter.VariableMap)
	})
}

func TestBuildLocalsForDirectory_ForwardReferences(t *testing.T) {
	t.Run("Should handle locals referencing locals defined later in same file", func(t *testing.T) {
		inputVariableMap = make(converter.VariableMap)
		currentPath := filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_locals", "forward_ref")

		localsMap, err := buildLocalsForDirectory(currentPath)
		require.NoError(t, err)

		// Check backend_name (defined after full_backend)
		backendName, exists := localsMap["backend_name"]
		require.True(t, exists, "backend_name should exist")
		require.Equal(t, "api", backendName.AsString())

		// Check full_backend references backend_name
		fullBackend, exists := localsMap["full_backend"]
		require.True(t, exists, "full_backend should exist")
		require.Equal(t, "api-production", fullBackend.AsString())

		// Check db_port (defined after connection_string)
		_, exists = localsMap["db_port"]
		require.True(t, exists, "db_port should exist")

		// Check connection_string references db_port
		connectionString, exists := localsMap["connection_string"]
		require.True(t, exists, "connection_string should exist")
		require.Equal(t, "localhost:5432", connectionString.AsString())
	})

	t.Cleanup(func() {
		inputVariableMap = make(converter.VariableMap)
		localsCache = make(map[string]converter.VariableMap)
	})
}

func TestBuildLocalsForDirectory_OverrideLocals(t *testing.T) {
	t.Run("Should handle locals overwriting other locals from different files", func(t *testing.T) {
		inputVariableMap = make(converter.VariableMap)
		currentPath := filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_locals", "override")

		localsMap, err := buildLocalsForDirectory(currentPath)
		require.NoError(t, err)

		// app_name will be either "first_name" or "overridden_name" depending on file processing order
		// Both files define app_name, and later file wins
		appName, exists := localsMap["app_name"]
		require.True(t, exists, "app_name should exist")
		require.NotNil(t, appName)

		// The value should be one of these two
		actualName := appName.AsString()
		require.True(t, actualName == "first_name" || actualName == "overridden_name",
			"app_name should be either 'first_name' or 'overridden_name', got: %s", actualName)

		// app_version should exist from override_locals_a.tf
		appVersion, exists := localsMap["app_version"]
		require.True(t, exists, "app_version should exist")
		require.Equal(t, "1.0.0", appVersion.AsString())
	})

	t.Cleanup(func() {
		inputVariableMap = make(converter.VariableMap)
		localsCache = make(map[string]converter.VariableMap)
	})
}

func TestBuildLocalsForDirectory_MultipleBlocks(t *testing.T) {
	t.Run("Should handle multiple locals blocks in same file", func(t *testing.T) {
		inputVariableMap = make(converter.VariableMap)
		currentPath := filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_locals", "multi_blocks")

		localsMap, err := buildLocalsForDirectory(currentPath)
		require.NoError(t, err)

		// Check all locals from multiple blocks
		firstLocal, exists := localsMap["first_local"]
		require.True(t, exists, "first_local should exist")
		require.Equal(t, "first", firstLocal.AsString())

		secondLocal, exists := localsMap["second_local"]
		require.True(t, exists, "second_local should exist")
		require.Equal(t, "second", secondLocal.AsString())

		thirdLocal, exists := localsMap["third_local"]
		require.True(t, exists, "third_local should exist")
		require.Equal(t, "third", thirdLocal.AsString())

		// Check combined local that references first and second
		combined, exists := localsMap["combined"]
		require.True(t, exists, "combined should exist")
		require.Equal(t, "first-second", combined.AsString())
	})

	t.Cleanup(func() {
		inputVariableMap = make(converter.VariableMap)
		localsCache = make(map[string]converter.VariableMap)
	})
}

func TestBuildLocalsForDirectory_CircularReference(t *testing.T) {
	t.Run("Should handle circular references gracefully", func(t *testing.T) {
		inputVariableMap = make(converter.VariableMap)
		currentPath := filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_locals", "circular")

		localsMap, err := buildLocalsForDirectory(currentPath)
		require.NoError(t, err)

		// Circular references should be stored as placeholders
		circularA, exists := localsMap["circular_a"]
		require.True(t, exists, "circular_a should exist")

		circularB, exists := localsMap["circular_b"]
		require.True(t, exists, "circular_b should exist")

		// Both should be string placeholders
		require.Equal(t, cty.String, circularA.Type())
		require.Equal(t, cty.String, circularB.Type())
	})

	t.Cleanup(func() {
		inputVariableMap = make(converter.VariableMap)
		localsCache = make(map[string]converter.VariableMap)
	})
}

func TestBuildLocalsForDirectory_WithVariables(t *testing.T) {
	t.Run("Should evaluate locals that reference variables", func(t *testing.T) {
		inputVariableMap = make(converter.VariableMap)

		// Set up some variables
		inputVariableMap["var"] = cty.ObjectVal(map[string]cty.Value{
			"environment": cty.StringVal("production"),
			"region":      cty.StringVal("us-east-1"),
			"prefix":      cty.StringVal("prod"),
		})

		currentPath := filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_locals", "with_vars")

		localsMap, err := buildLocalsForDirectory(currentPath)
		require.NoError(t, err)

		// Check locals that reference variables
		resourcePrefix, exists := localsMap["resource_prefix"]
		require.True(t, exists, "resource_prefix should exist")
		require.Equal(t, "production-us-east-1", resourcePrefix.AsString())

		tagName, exists := localsMap["tag_name"]
		require.True(t, exists, "tag_name should exist")
		require.Equal(t, "production", tagName.AsString())
	})

	t.Cleanup(func() {
		inputVariableMap = make(converter.VariableMap)
		localsCache = make(map[string]converter.VariableMap)
	})
}

func TestGetLocals(t *testing.T) {
	tests := []struct {
		name        string
		currentPath string
		wantKeys    []string
	}{
		{
			name:        "Should load locals and populate inputVariableMap",
			currentPath: filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_locals", "isolated"),
			wantKeys:    []string{"isolated_value"},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			inputVariableMap = make(converter.VariableMap)
			localsCache = make(map[string]converter.VariableMap)

			getLocals(tt.currentPath)

			localObj, exists := inputVariableMap["local"]
			require.True(t, exists, "inputVariableMap should contain 'local' key")

			localMap := localObj.AsValueMap()
			require.Equal(t, len(tt.wantKeys), len(localMap))

			for _, key := range tt.wantKeys {
				_, exists := localMap[key]
				require.True(t, exists, "Expected local '%s' not found", key)
			}
		})
	}

	t.Cleanup(func() {
		inputVariableMap = make(converter.VariableMap)
		localsCache = make(map[string]converter.VariableMap)
	})
}

func TestGetLocals_Caching(t *testing.T) {
	tests := []struct {
		name             string
		firstCallPath    string
		secondCallPath   string
		shouldUseCache   bool
		expectedKeyCount int
	}{
		{
			name:             "Should use cache for same directory",
			firstCallPath:    filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_locals", "isolated"),
			secondCallPath:   filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_locals", "isolated"),
			shouldUseCache:   true,
			expectedKeyCount: 1,
		},
		{
			name:             "Should not use cache for different directory",
			firstCallPath:    filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_locals", "isolated"),
			secondCallPath:   filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_variables"),
			shouldUseCache:   false,
			expectedKeyCount: 0,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			localsCache = make(map[string]converter.VariableMap)
			inputVariableMap = make(converter.VariableMap)

			getLocals(tt.firstCallPath)

			cacheSize := len(localsCache)
			require.Equal(t, 1, cacheSize, "cache should have one entry after first call")

			getLocals(tt.secondCallPath)

			if tt.shouldUseCache {
				require.Equal(t, cacheSize, len(localsCache), "cache size should not change when reusing cache")
			} else {
				require.Equal(t, cacheSize+1, len(localsCache), "cache should grow for new directory")
			}

			if tt.expectedKeyCount > 0 {
				localObj, ok := inputVariableMap["local"]
				require.True(t, ok, "inputVariableMap should contain 'local' key")
				require.Equal(t, tt.expectedKeyCount, len(localObj.AsValueMap()), "wrong number of locals")
			}
		})
	}

	t.Cleanup(func() {
		inputVariableMap = make(converter.VariableMap)
		localsCache = make(map[string]converter.VariableMap)
	})
}

func TestGetLocals_Integration(t *testing.T) {
	t.Run("Should work with getInputVariables for complete parsing", func(t *testing.T) {
		inputVariableMap = make(converter.VariableMap)
		localsCache = make(map[string]converter.VariableMap)
		variableCache = make(map[string]converter.VariableMap)

		currentPath := filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_locals", "with_vars")
		fileContent, err := os.ReadFile(filepath.Join(currentPath, "locals_with_vars.tf"))
		require.NoError(t, err)

		// First load variables
		getInputVariables(currentPath, string(fileContent), "")

		// Then load locals
		getLocals(currentPath)

		// Check that both var and local are in inputVariableMap
		_, varExists := inputVariableMap["var"]
		require.True(t, varExists, "var should exist in inputVariableMap")

		localObj, localExists := inputVariableMap["local"]
		require.True(t, localExists, "local should exist in inputVariableMap")

		// Verify locals can use variables
		localMap := localObj.AsValueMap()
		require.NotEmpty(t, localMap, "locals map should not be empty")
	})

	t.Cleanup(func() {
		inputVariableMap = make(converter.VariableMap)
		localsCache = make(map[string]converter.VariableMap)
		variableCache = make(map[string]converter.VariableMap)
	})
}
