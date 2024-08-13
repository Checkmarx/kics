/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package model

type SCIInfo struct {
	DiffAware DiffAware
}

// DiffAware contains the necessary information to be able to perform a diff between two reports
type DiffAware struct {
	Enabled      bool   `json:"enabled"`
	ConfigDigest string `json:"config_digest"`
	BaseSha      string `json:"base_sha"`
	Files        string `json:"files"`
}
