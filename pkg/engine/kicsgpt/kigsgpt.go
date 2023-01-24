// integrations with kicsGPT proxy
package kicsgpt

import (
	"github.com/Checkmarx/kics/pkg/engine/kicsgpt/model"
)

var (
	gptClient     HTTPKicsGPT = &Client{}
	queryId                   = "4b564d2b-a364-44be-b0fe-42e1370efa75"
	descriptionID             = "e96f009f"
)

func GetFileEvaluation(fileData string, fileID string) (interface{}, error) {
	if err := gptClient.CheckConnection(); err != nil {
		return nil, err
	}

	output, err := gptClient.RequestEvaluation(fileData)
	if err != nil {
		return nil, err
	}

	vulnerabilities := make([]interface{}, 0)

	for _, val := range output.Vulnerabilities {
		vuln := buildVulnerability(val, fileID)
		vulnerabilities = append(vulnerabilities, vuln)
	}
	return vulnerabilities, nil
}

func buildVulnerability(vuln model.GPTVulnerability, fileID string) interface{} {
	return map[string]interface{}{
		"keyActualValue":   vuln.KeyActualValue,
		"resourceName":     vuln.ResourceName,
		"searchKey":        "",
		"descriptionID":    descriptionID,
		"queryName":        "CHAT GPT: " + vuln.VulnerabilityName,
		"issueType":        vuln.IssueType,
		"resourceType":     vuln.ResourceType,
		"platform":         vuln.Platform,
		"severity":         vuln.Severity,
		"documentId":       fileID,
		"keyExpectedValue": vuln.KeyExpectedValue,
		"descriptionUrl":   vuln.Url,
		"id":               queryId,
		"category":         vuln.VulnerabilityName,
		"descriptionText":  vuln.Description,
		"cloudProvider":    vuln.CloudProvider,
	}
}
