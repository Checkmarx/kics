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
