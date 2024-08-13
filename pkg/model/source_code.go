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
