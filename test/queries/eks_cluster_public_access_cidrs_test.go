package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_EKS_Cluster_Public_Access_cidrs(t *testing.T) {
	const query = "EKS_Cluster_Public_Access_cidrs.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      8,
				Severity:  model.SeverityHigh,
				QueryName: "EKS cluster public access cidrs",
			},
			{
				Line:      30,
				Severity:  model.SeverityHigh,
				QueryName: "EKS cluster public access cidrs",
			},
		},
	)
}

func Test_EKS_Cluster_Public_Access_cidrs_Success(t *testing.T) {
	const query = "EKS_Cluster_Public_Access_cidrs.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
