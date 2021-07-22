package model

// DescriptionRequest - is the model for the description request
type DescriptionRequest struct {
	DescriptionIDs []string `json:"descriptions"`
	Version        string   `json:"version"`
}

type CISDescriptions struct {
	DescriptionID    string `json:"cisDescriptionID"`
	DescriptionTitle string `json:"cisDescriptionTitle"`
	RationaleText    string `json:"cisRationaleText"`
	FixText          string `json:"cisFixText"`
	BenchmarkName    string `json:"cisBenchmarkName"`
	BenchmarkVersion string `json:"cisBenchmarkVersion"`
}

// DescriptionResponse - is the model for the description response
type DescriptionResponse struct {
	ID           string                     `json:"RequestID"`
	Descriptions map[string]CISDescriptions `json:"Descriptions"`
	Timestamp    string                     `json:"Timestamp"`
}
