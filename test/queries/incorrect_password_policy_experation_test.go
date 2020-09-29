package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_Incorrect_Password_Policy_Experation(t *testing.T) {
	const query = "Incorrect_Password_Policy_Experation.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      12,
				Severity:  model.SeverityMedium,
				QueryName: "Incorrect password policy expiration",
			},
			{
				Line:      8,
				Severity:  model.SeverityMedium,
				QueryName: "Incorrect password policy expiration",
			},
		},
	)
}

func Test_Incorrect_Password_Policy_Experation_Success(t *testing.T) {
	const query = "Incorrect_Password_Policy_Experation.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
