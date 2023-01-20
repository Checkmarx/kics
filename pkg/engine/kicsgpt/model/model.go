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
	VulnerabilityName string `json:"vulnerability"`
	Accuracy          string `json:"accuracy"`
	Category          string `json:"category"`
	Description       string `json:"description"`
	Severity          string `json:"severity"`
	CloudProvider     string `json:"cloud_provider"`
	Platform          string `json:"platform"`
	Code              string `json:"code"`
	Url               string `json:"url"`
	Fix               string `json:"fix"`
}
