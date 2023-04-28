// Package model provides a model for the telemetry request
package model

// DescriptionRequest - is the model for the description request
type DescriptionRequest struct {
	DescriptionIDs []string `json:"descriptions"`
	Version        string   `json:"version"`
}

// Descriptions - is the model for the description response
type Descriptions struct {
	DescriptionID    string `json:"descriptionRuleID"`
	DescriptionTitle string `json:"descriptionTitle"`
	DescriptionText  string `json:"descriptionText"`
}

// DescriptionResponse - is the model for the description response
type DescriptionResponse struct {
	ID           string                  `json:"RequestID"`
	Descriptions map[string]Descriptions `json:"Descriptions"`
	Timestamp    string                  `json:"Timestamp"`
}

// VersionRequest - is the model for the version request
type VersionRequest struct {
	Version string `json:"version"`
}
