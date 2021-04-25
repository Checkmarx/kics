package additional

import (
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestAddSwaggerInfo(t *testing.T) {
	path := filepath.Join("..", "..", "..", "test", "fixtures", "test_swagger", "positive3.yaml")
	swaggerPath := "swaggerFileWithoutAuthorizer.yaml"

	info := AddSwaggerInfo(path, swaggerPath)

	require.NotNil(t, info)
}
