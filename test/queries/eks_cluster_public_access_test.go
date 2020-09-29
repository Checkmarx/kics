package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_EKS_Cluster_Public_Access(t *testing.T) {
	const query = "EKS_Cluster_Public_Access.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      7,
				Severity:  model.SeverityMedium,
				QueryName: "EKS cluster public access",
			},
		},
	)
}

func Test_EKS_Cluster_Public_Access_Success(t *testing.T) {
	const query = "EKS_Cluster_Public_Access.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
