package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_Open_Access_to_Resources_through_API(t *testing.T) {
	const query = "Open_Access_to_Resources_through_API.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
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
	const query = "Open_Access_to_Resources_through_API.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
