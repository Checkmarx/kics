package utils

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestNextRandom(t *testing.T) {
	a := NextRandom()
	b := NextRandom()

	require.NotEqual(t, a, b)
}
