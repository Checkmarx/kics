package utils

import (
	"os"
	"strconv"
	"sync"
	"time"
)

// ======== Golang way to create random number for tmp dir naming =============
var rand uint32
var randmu sync.Mutex

const tempDirFormat = 1e9

func reseed() uint32 {
	return uint32(int32(time.Now().UnixNano()) + int32(os.Getpid())) //nolint:gosec
}

// NextRandom returns a random number
func NextRandom() string {
	randmu.Lock()
	r := rand
	if r == 0 {
		r = reseed()
	}
	r = r*1664525 + 1013904223 // constants from Numerical Recipes
	rand = r
	randmu.Unlock()
	return strconv.Itoa(int(tempDirFormat + r%tempDirFormat))[1:]
}

// ==============================================================================
