package utils

import (
	"runtime"
	"testing"

	"github.com/stretchr/testify/require"
)

func Test_AdjustWorkers(t *testing.T) {
	workers0 := AdjustNumWorkers(0)
	require.Equal(t, workers0, runtime.GOMAXPROCS(-1))
	workers1 := AdjustNumWorkers(1)
	require.Equal(t, workers1, 1)
	workersnegative1 := AdjustNumWorkers(-1)
	require.Equal(t, workersnegative1, -1)
	workers100 := AdjustNumWorkers(100)
	require.Equal(t, workers100, 100)
}
