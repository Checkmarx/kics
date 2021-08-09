package descriptions

import (
	"testing"

	mockclient "github.com/Checkmarx/kics/pkg/descriptions/mock"
	"github.com/Checkmarx/kics/pkg/descriptions/model"
	"github.com/Checkmarx/kics/test"
	"github.com/stretchr/testify/require"
)

func TestRequestAndOverrideDescriptions_NoBaseURL(t *testing.T) {
	mock := test.SummaryMock
	descClient = &mockclient.MockDecriptionsClient{}
	mockclient.CheckConnection = func() error {
		return nil
	}
	mockclient.GetDescriptions = func(descriptionIDs []string) (map[string]model.CISDescriptions, error) {
		return map[string]model.CISDescriptions{
			"504b1d43": {
				DescriptionID:    "1",
				DescriptionTitle: "my title",
				RationaleText:    "my rattionale",
			},
		}, nil
	}
	err := RequestAndOverrideDescriptions(&mock)
	require.NoError(t, err, "Expected error")
	for _, query := range mock.Queries {
		if query.DescriptionID == "504b1d43" {
			require.Equal(t, "my title", query.CISDescriptionTitle, "Expected cis description to be equal")
		}
	}
}
