package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_Cloudwatch_without_Retention_Days(t *testing.T) {
	const query = "aws/Cloudwatch_without_Retention_Days.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
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
	const query = "aws/Cloudwatch_without_Retention_Days.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
