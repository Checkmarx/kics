package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_IAM_Policies_with_Full_Pivileges(t *testing.T) {
	const query = "IAM_Policies_with_Full_Pivileges.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      11,
				Severity:  model.SeverityMedium,
				QueryName: "IAM policies with full privileges",
			},
		},
	)
}

func Test_IAM_Policies_with_Full_Pivileges_Success(t *testing.T) {
	const query = "IAM_Policies_with_Full_Pivileges.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
