package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_Public_ECR_Policy(t *testing.T) {
	const query = "aws/Public_ECR_Policy.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
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
	const query = "aws/Public_ECR_Policy.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
