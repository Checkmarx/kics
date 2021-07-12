package model

// DescriptionRequest - is the model for the description request
type DescriptionRequest struct {
	DescriptionIDs []string `json:"descriptions"`
	Version        string   `json:"version"`
}

// DescriptionResponse - is the model for the description response
type DescriptionResponse struct {
	ID           string            `json:"RequestID"`
	Descriptions map[string]string `json:"Descriptions"`
	Timestamp    string            `json:"Timestamp"`
}
