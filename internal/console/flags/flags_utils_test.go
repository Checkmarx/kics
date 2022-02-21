package flags

import (
	"testing"

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
