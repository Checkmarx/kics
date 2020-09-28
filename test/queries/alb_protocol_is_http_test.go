package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_ALB_Protocol_is_HTTP(t *testing.T) {
	const queryPath = "ALB_Protocol_is_HTTP.rego"

	checkQuery(
		t,
		queryPath,
		queryTerraformFile(queryPath),
		[]model.Vulnerability{
			{
				Line:      25,
				Severity:  model.SeverityHigh,
				QueryName: "ALB protocol is HTTP",
			},
			{
				Line:      19,
				Severity:  model.SeverityHigh,
				QueryName: "ALB protocol is HTTP",
			},
		},
	)
}

func Test_ALB_Protocol_is_HTTP_Success(t *testing.T) {
	const queryPath = "ALB_Protocol_is_HTTP.rego"

	checkQuery(
		t,
		queryPath,
		queryTerraformSuccessFile(queryPath),
		[]model.Vulnerability{},
	)
}
