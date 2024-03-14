package utils

import "runtime"

func AdjustNumWorkers(workers int) int {
	// for the case in which the end user decides to use num workers as "auto-detected"
	// we will set the number of workers to the number of CPUs available based on GOMAXPROCS value
	if workers == 0 {
		return runtime.GOMAXPROCS(-1)
	}
	return workers
}
