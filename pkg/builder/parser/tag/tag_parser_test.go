package tag

import (
	"testing"

	"github.com/stretchr/testify/require"
)

// TestParseTags tests the functions [Parse()] and all the methods called by them (check for equal flags)
func TestParseTags(t *testing.T) { //nolint
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
		tags, err := Parse("// a:\"something,expected=private,test=false,test2=true,iii=123.3,tt=['a','c']\" commentB a:\"test=1,b,c=!=\"", []string{"a", "commentB"}) //nolint:lll
		require.NoError(t, err)
		assertEqualTags(t, tags, []Tag{
			{
				Name: "a",
				Attributes: map[string]interface{}{
					"something": nil,
					"expected":  "private",
					"test":      false,
					"test2":     true,
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

	t.Run("parse_args", func(t *testing.T) {
		tags, err := Parse("// Test:testArr[a=testA,b=testB]", []string{"Test"})
		require.NoError(t, err)
		assertEqualTags(t, tags, []Tag{
			{
				Name: "Test",
				Attributes: map[string]interface{}{
					"testArr": map[string]interface{}{
						"a": "testA",
						"b": "testB",
					},
				},
			},
		})
	})

	t.Run("parse_escape", func(t *testing.T) {
		tags, err := Parse("// a:tt=['a\\a','b\\b','f\\f','n\\n','r\\r','t\\t','v\\v']", []string{"a"}) //nolint:lll
		require.NoError(t, err)
		assertEqualTags(t, tags, []Tag{
			{
				Name: "a",
				Attributes: map[string]interface{}{
					"tt": []interface{}{
						"a\a",
						"b\b",
						"f\f",
						"n\n",
						"r\r",
						"t\t",
						"v\v",
					},
				},
			},
		})
	})

	t.Run("special_escape_cases", func(t *testing.T) {
		tags, err := Parse("// Test:t='\\\\',pel='\\'',asp='\\\"\\\"'", []string{"Test"})
		require.NoError(t, err)
		assertEqualTags(t, tags, []Tag{
			{
				Name: "Test",
				Attributes: map[string]interface{}{
					"t":   "\\",
					"pel": "'",
					"asp": "\"\"",
				},
			},
		})
	})
}

// TestParseTags tests the functions [Parse()] and all the methods called by them (checks for errors)
func TestParseErrorTags(t *testing.T) {
	t.Run("invalid_token", func(t *testing.T) {
		tags, err := Parse("// Test:[error]", []string{"Test"})
		require.Error(t, err)
		assertEqualTags(t, tags, nil)
	})

	t.Run("parse_args_error", func(t *testing.T) {
		tags, err := Parse("// Test:testArr[testA]", []string{"Test"})
		require.Error(t, err)
		assertEqualTags(t, tags, nil)
	})

	t.Run("invalid_value_error", func(t *testing.T) {
		tags, err := Parse("// Test:t=!test", []string{"Test"})
		require.Error(t, err)
		assertEqualTags(t, tags, nil)
	})

	t.Run("invalid_escape_sequence", func(t *testing.T) {
		tags, err := Parse("// Test:t='\\k'", []string{"Test"})
		require.Error(t, err)
		assertEqualTags(t, tags, nil)
	})

	t.Run("unterminated_string", func(t *testing.T) {
		tags, err := Parse("// Test:t='\n'", []string{"Test"})
		require.Error(t, err)
		assertEqualTags(t, tags, nil)
	})

	t.Run("']'_or_','_expected_error", func(t *testing.T) {
		tags, err := Parse("// Test:t=['a')", []string{"Test"})
		require.Error(t, err)
		assertEqualTags(t, tags, nil)
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
