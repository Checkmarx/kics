/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package constants

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestConstants_GetRelease(t *testing.T) {
	got := GetRelease()
	require.Equal(t, "kics@development", got)
}

func TestConstants_GetVersion(t *testing.T) {
	got := GetVersion()
	require.Equal(t, "Keeping Infrastructure as Code Secure development", got)
}

func TestConstants_GetDefaultLogPath(t *testing.T) {
	workDir, _ := os.Getwd()
	got, err := GetDefaultLogPath()
	require.NoError(t, err)
	require.Equal(t, filepath.Join(workDir, DefaultLogFile), got)
}
