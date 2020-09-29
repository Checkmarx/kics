package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_Hard_Coded_AWS_Access_Key(t *testing.T) {
	const query = "Hard_Coded_AWS_Access_Key.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      14,
				Severity:  model.SeverityLow,
				QueryName: "Hardcoded AWS access key",
			},
			{
				Line:      41,
				Severity:  model.SeverityLow,
				QueryName: "Hardcoded AWS access key",
			},
		},
	)
}

func Test_Hard_Coded_AWS_Access_Key_Success(t *testing.T) {
	const query = "Hard_Coded_AWS_Access_Key.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
