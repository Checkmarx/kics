package utils

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestKicsDevPathAdapterHelmOverrides(t *testing.T) {
	for input, want := range map[string]string{
		`message=hello\,world`: `message=hello\,world`,
		"items={one,two}":      "items={one,two}",
		"/path/e2e/fixtures/chart::/path/e2e/fixtures/values.yaml": "fixtures/chart::fixtures/values.yaml",
		`/path/e2e/fixtures/chart::message=hello\,world`:           `fixtures/chart::message=hello\,world`,
		"/path/test/chart::/path/e2e/fixtures/values.yaml":         "../test/chart::fixtures/values.yaml",
	} {
		t.Run(input, func(t *testing.T) {
			require.Equal(t, want, KicsDevPathAdapter(input))
		})
	}
}
