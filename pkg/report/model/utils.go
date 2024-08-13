/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package model

import (
	"fmt"

	"github.com/Checkmarx/kics/pkg/model"
)

func GetScanDurationTag(summary model.Summary) string {
	scanDuration := summary.Times.End.Sub(summary.Times.Start).Seconds()
	executionTimeTag := fmt.Sprintf(executionTimeTag, scanDuration)
	return executionTimeTag
}

func GetDiffAwareEnabledTag(diffAware model.DiffAware) string {
	return fmt.Sprintf(diffAwareEnabledTag, diffAware.Enabled)
}

func GetDiffAwareConfigDigestTag(diffAware model.DiffAware) string {
	return fmt.Sprintf(diffAwareConfigDigestTag, diffAware.ConfigDigest)
}

func GetDiffAwareBaseShaTag(diffAware model.DiffAware) string {
	return fmt.Sprintf(diffAwareBaseShaTag, diffAware.BaseSha)
}

func GetDiffAwareFilesTag(diffAware model.DiffAware) string {
	return fmt.Sprintf(diffAwareFileTag, diffAware.Files)
}
