package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_Public_ECR_Policy(t *testing.T) {
	const query = "Public_ECR_Policy.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      8,
				Severity:  model.SeverityMedium,
				QueryName: "Public ECR policy",
			},
		},
	)
}

func Test_Public_ECR_Policy_Success(t *testing.T) {
	const query = "Public_ECR_Policy.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
