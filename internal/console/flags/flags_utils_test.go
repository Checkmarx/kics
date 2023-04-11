package flags

import (
	"testing"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"github.com/stretchr/testify/require"
)

func TestFlags_FormatNewError(t *testing.T) {
	tests := []struct {
		name  string
		flag1 string
		flag2 string
		want  string
	}{
		{
			name:  "should correctly format error for 'test1' and 'test2' flags",
			flag1: "test1",
			flag2: "test2",
			want:  "can't provide 'test1' and 'test2' flags simultaneously",
		},
		{
			name:  "should correctly format error for 'flag1' and 'flag2' flags",
			flag1: "flag1",
			flag2: "flag2",
			want:  "can't provide 'flag1' and 'flag2' flags simultaneously",
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got := FormatNewError(test.flag1, test.flag2)
			require.EqualError(t, got, test.want)
		})
	}
}

func TestFlags_ValidateQuerySelectionFlags(t *testing.T) {
	got := ValidateQuerySelectionFlags()
	require.NoError(t, got)

	multiFlag := []string{"test", "kics"}
	flagsMultiStrReferences[IncludeQueriesFlag] = &multiFlag
	flagsMultiStrReferences[ExcludeCategoriesFlag] = &multiFlag

	got = ValidateQuerySelectionFlags()
	require.Error(t, got)

	flagsMultiStrReferences[ExcludeQueriesFlag] = &multiFlag

	got = ValidateQuerySelectionFlags()
	require.Error(t, got)
}

func TestFlags_ValidateTypeSelectionFlags(t *testing.T) {
	//Default behavior
	flagsMultiStrReferences[TypeFlag] = &[]string{""}
	flagsMultiStrReferences[ExcludeTypeFlag] = &[]string{""}
	got := ValidateTypeSelectionFlags()
	require.NoError(t, got)

	multiFlag := []string{"test", "kics"}
	flagsMultiStrReferences[TypeFlag] = &multiFlag
	flagsMultiStrReferences[ExcludeTypeFlag] = &multiFlag

	got = ValidateTypeSelectionFlags()
	require.Error(t, got)

	flagsMultiStrReferences[ExcludeTypeFlag] = &[]string{""}

	got = ValidateTypeSelectionFlags()
	require.NoError(t, got)
}

func TestFlags_BindFlags(t *testing.T) {
	mockCmd := &cobra.Command{
		Use:   "mock",
		Short: "Mock cmd",
		RunE: func(cmd *cobra.Command, args []string) error {
			return nil
		},
	}
	v := viper.New()
	v.SetEnvPrefix("KICS")
	v.AutomaticEnv()
	v.Set("queries-path", []interface{}{"./assets/queries", "./test"})
	v.Set("preview-lines", 3)

	tests := []struct {
		name                    string
		cmd                     *cobra.Command
		flagsListContent        string
		persistentFlag          bool
		supportedPlatforms      []string
		supportedCloudProviders []string
		wantErr                 bool
	}{
		{
			name: "should bind flags without error",
			cmd:  mockCmd,
			flagsListContent: `{"log-level": {
				"flagType": "str",
				"shorthandFlag": "",
				"defaultValue": "INFO",
				"usage": "determines log level (${supportedLogLevels})",
				"validation": "validateStrEnum"
			},"preview-lines": {
				"flagType": "int",
				"shorthandFlag": "",
				"defaultValue": "3",
				"usage": "number of lines to be display in CLI results (min: 1, max: 30)"
			},"queries-path": {
				"flagType": "multiStr",
				"shorthandFlag": "q",
				"defaultValue": "./assets/queries",
				"usage": "paths to directory with queries"
			}}`,
			persistentFlag:          false,
			supportedPlatforms:      []string{"terraform"},
			supportedCloudProviders: []string{"aws"},
			wantErr:                 false,
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			InitJSONFlags(test.cmd, test.flagsListContent, test.persistentFlag, test.supportedPlatforms, test.supportedCloudProviders)
			got := BindFlags(test.cmd, v)
			if !test.wantErr {
				require.NoError(t, got)
			} else {
				require.Error(t, got)
			}
		})
	}
}
