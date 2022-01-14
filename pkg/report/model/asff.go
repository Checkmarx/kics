package model

import (
	"fmt"
	"os"
	"time"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/rs/zerolog/log"
)

// AwsAccountInfo contains all the relevant information of the user AWS account
type AwsAccountInfo struct {
	AwsAccountID string
	AwsRegion    string
}

// AwsSecurityFinding contains all the relevant information to build a finding
type AwsSecurityFinding struct {
	AwsAccountID  string `json:"AwsAccountId"`
	Compliance    Compliance
	CreatedAt     string
	Description   string
	GeneratorID   string `json:"GeneratorId"`
	ID            string `json:"Id"`
	ProductArn    string
	Remediation   Remediation
	Resources     []Resource
	SchemaVersion string
	Severity      Severity
	Title         string
	Types         []string
	UpdatedAt     string
}

// AsffRecommendation includes the recommendation to avoid the finding
type AsffRecommendation struct {
	Text string
}

// Remediation contains the recommendation
type Remediation struct {
	Recommendation AsffRecommendation
}

// Resource contains the ID and the type of the target resource
type Resource struct {
	ID   string `json:"Id"`
	Type string
}

// Severity contains the original severity (KICS severity) and the label severity (ASFF severity)
type Severity struct {
	Original string
	Label    string
}

// Compliance contains the status of the finding
type Compliance struct {
	Status string
}

// BuildASFF builds the ASFF report
func BuildASFF(summary *model.Summary) []AwsSecurityFinding {
	var findings []AwsSecurityFinding

	awsAccountInfo := getAwsAccountInfo()

	if awsAccountInfo.incompleteAwsAccountInfo() {
		variables := "AWS_ACCOUNT_ID, AWS_REGION"
		log.Debug().Msg(fmt.Sprintf("failed to get AWS account information: check your environment variables (%s)", variables))
	}

	for idx := range summary.Queries {
		query := summary.Queries[idx]

		if query.CloudProvider == "AWS" {
			for i := range query.Files {
				finding := awsAccountInfo.getFinding(&query, &query.Files[i])
				findings = append(findings, finding)
			}
		}
	}

	return findings
}

func (a *AwsAccountInfo) getFinding(query *model.QueryResult, file *model.VulnerableFile) AwsSecurityFinding {
	awsAccountID := a.AwsAccountID
	awsRegion := a.AwsRegion

	timeFormatted := time.Now().Format(time.RFC3339)

	arn := "arn:aws:securityhub:%s:%s:product/%s/default"
	arn = fmt.Sprintf(arn, awsRegion, awsAccountID, awsAccountID)

	severity := string(query.Severity)
	if severity == "INFO" {
		severity = "INFORMATIONAL"
	}

	finding := AwsSecurityFinding{
		AwsAccountID: *aws.String(awsAccountID),
		CreatedAt:    *aws.String(timeFormatted),
		Description:  *aws.String(getDescription(query, "asff")),
		GeneratorID:  *aws.String(query.QueryID),
		ID:           *aws.String(fmt.Sprintf("%s/%s/%s", awsRegion, awsAccountID, file.SimilarityID)),
		ProductArn:   *aws.String(arn),
		Resources: []Resource{
			{
				ID:   *aws.String(query.QueryID),
				Type: *aws.String("Other"),
			},
		},
		SchemaVersion: *aws.String("2018-10-08"),
		Severity: Severity{
			Original: *aws.String(string(query.Severity)),
			Label:    *aws.String(severity),
		},
		Title:     *aws.String(query.QueryName),
		Types:     []string{*aws.String("Software and Configuration Checks/Vulnerabilities/KICS")},
		UpdatedAt: *aws.String(timeFormatted),

		Remediation: Remediation{
			Recommendation: AsffRecommendation{
				Text: *aws.String(fmt.Sprintf("In line %d of file %s, a result was found. %s, but %s",
					file.Line, file.FileName, file.KeyActualValue, file.KeyExpectedValue)),
			},
		},
		Compliance: Compliance{Status: *aws.String("FAILED")},
	}

	return finding
}

func getEnv(env string) string {
	if len(os.Getenv(env)) > 0 {
		return os.Getenv(env)
	}

	return env
}

func getAwsAccountInfo() *AwsAccountInfo {
	awsAccountInfo := AwsAccountInfo{
		AwsAccountID: getEnv("AWS_ACCOUNT_ID"),
		AwsRegion:    getEnv("AWS_REGION"),
	}

	return &awsAccountInfo
}

func (a *AwsAccountInfo) incompleteAwsAccountInfo() bool {
	if a.AwsAccountID == "" || a.AwsRegion == "" {
		return true
	}

	return false
}
