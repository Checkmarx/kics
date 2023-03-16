package model

// DescriptionRequest - is the model for the description request
type GPTRequest struct {
	FileContent string `json:"fileContent"`
}

// DescriptionResponse - is the model for the description response
type GPTResponse struct {
	Vulnerabilities []GPTVulnerability `json:"Vulnerabilities"`
}

type GPTVulnerability struct {
	VulnerabilityName string  `json:"vulnerability"`
	Accuracy          float64 `json:"accuracy"`
	Category          string  `json:"category"`
	Description       string  `json:"description"`
	Severity          string  `json:"severity"`
	CloudProvider     string  `json:"cloud_provider"`
	Platform          string  `json:"platform"`
	Code              []int   `json:"code"`
	Url               string  `json:"url"`
	Fix               string  `json:"fix"`
	KeyExpectedValue  string  `json:"key_expected_value"`
	KeyActualValue    string  `json:"key_actual_value"`
	ResourceType      string  `json:"resource_type"`
	IssueType         string  `json:"issue_type"`
	ResourceName      string  `json:"resource_name"`
}
