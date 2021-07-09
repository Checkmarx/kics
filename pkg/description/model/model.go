package model

// DescriptionRequest - is the model for the description request
type DescriptionRequest struct {
	DescriptionIDs []string `json:"descriptions"`
}

// DescriptionResponse - is the model for the description response
type DescriptionResponse struct {
	ID           string            `json:"AWSRequestID"`
	Descriptions map[string]string `json:"Descriptions"`
	Timestamp    string            `json:"Timestamp"`
}
