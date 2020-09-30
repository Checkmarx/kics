package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_Incorrect_Password_Policy_Experation(t *testing.T) {
	const query = "aws/Incorrect_Password_Policy_Experation.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
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
	const query = "aws/Incorrect_Password_Policy_Experation.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
