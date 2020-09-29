package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_Open_Access_to_Resources_through_API(t *testing.T) {
	const query = "aws/Open_Access_to_Resources_through_API.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      16,
				Severity:  model.SeverityLow,
				QueryName: "Open access to resources through API",
			},
		},
	)
}

func Test_Open_Access_to_Resources_through_API_Success(t *testing.T) {
	const query = "aws/Open_Access_to_Resources_through_API.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
