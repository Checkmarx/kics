package tag

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestParseTags(t *testing.T) {
	t.Run("empty", func(t *testing.T) {
		tags, err := Parse("", []string{"test2"})
		require.NoError(t, err)
		assertEqualTags(t, tags, []Tag{})
	})

	t.Run("not_supported", func(t *testing.T) {
		tags, err := Parse("// test", []string{"test2"})
		require.NoError(t, err)
		assertEqualTags(t, tags, []Tag{})
	})

	t.Run("just_comment", func(t *testing.T) {
		tags, err := Parse("// test", []string{"test"})
		require.NoError(t, err)
		assertEqualTags(t, tags, []Tag{
			{
				Name: "test",
			},
		})
	})

	t.Run("just_many_comments", func(t *testing.T) {
		tags, err := Parse("// a commentB", []string{"a", "commentB"})
		require.NoError(t, err)
		assertEqualTags(t, tags, []Tag{
			{
				Name: "a",
			},
			{
				Name: "commentB",
			},
		})
	})

	t.Run("just_many_comments", func(t *testing.T) {
		tags, err := Parse("// a:\"something,expected=private,test=false,iii=123.3,tt=['a','c']\" commentB a:\"test=1,b,c=!=\"", []string{"a", "commentB"}) // nolint:lll
		require.NoError(t, err)
		assertEqualTags(t, tags, []Tag{
			{
				Name: "a",
				Attributes: map[string]interface{}{
					"something": nil,
					"expected":  "private",
					"test":      false,
					"iii":       123.3,
					"tt":        []interface{}{"a", "c"},
				},
			},
			{
				Name: "commentB",
			},
			{
				Name: "a",
				Attributes: map[string]interface{}{
					"test": int64(1),
					"b":    nil,
					"c":    "!=",
				},
			},
		})
	})

	t.Run("all_attributes", func(t *testing.T) {
		tags, err := Parse("// Test:\"r=*,resource=['a','b','c'],any_key,upper,lower,con=<=,con2=>\"", []string{"Test"})
		require.NoError(t, err)
		assertEqualTags(t, tags, []Tag{
			{
				Name: "Test",
				Attributes: map[string]interface{}{
					"r": "*",
					"resource": []interface{}{
						"a", "b", "c",
					},
					"any_key": nil,
					"upper":   nil,
					"lower":   nil,
					"con":     "<=",
					"con2":    ">",
				},
			},
		})
	})
}

func assertEqualTags(t *testing.T, actual, expected []Tag) {
	require.Len(t, actual, len(expected))
	for i, ex := range expected {
		ac := actual[i]
		require.Equal(t, ex.Name, ac.Name)
		require.Len(t, ac.Attributes, len(ex.Attributes))
		for exAttrKey, exAttrValue := range ex.Attributes {
			acAttrValue, ok := ac.Attributes[exAttrKey]

			require.True(t, ok)
			require.Equal(t, exAttrValue, acAttrValue)
		}
	}
}
