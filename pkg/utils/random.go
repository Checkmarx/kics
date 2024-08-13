/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
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
	return uint32(time.Now().UnixNano() + int64(os.Getpid()))
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
