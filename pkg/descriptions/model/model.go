/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package model

// DescriptionRequest - is the model for the description request
type DescriptionRequest struct {
	DescriptionIDs []string `json:"descriptions"`
	Version        string   `json:"version"`
}

// CISDescriptions - is the model for the description response
type CISDescriptions struct {
	DescriptionID    string `json:"cisDescriptionRuleID"`
	DescriptionTitle string `json:"cisDescriptionTitle"`
	DescriptionText  string `json:"cisDescriptionText"`
	RationaleText    string `json:"cisRationaleText"`
	BenchmarkName    string `json:"cisBenchmarkName"`
	BenchmarkVersion string `json:"cisBenchmarkVersion"`
}

// DescriptionResponse - is the model for the description response
type DescriptionResponse struct {
	ID           string                     `json:"RequestID"`
	Descriptions map[string]CISDescriptions `json:"Descriptions"`
	Timestamp    string                     `json:"Timestamp"`
}

// VersionRequest - is the model for the version request
type VersionRequest struct {
	Version string `json:"version"`
}
