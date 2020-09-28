package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_Cloudwatch_without_Retention_Days(t *testing.T) {
	const query = "Cloudwatch_without_Retention_Days.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      7,
				Severity:  model.SeverityLow,
				QueryName: "Cloudwatch without retention days",
			},
		},
	)
}

func Test_Cloudwatch_without_Retention_Days_Success(t *testing.T) {
	const query = "Cloudwatch_without_Retention_Days.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
