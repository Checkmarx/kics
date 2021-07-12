package descriptions

import (
	"testing"

	mock_client "github.com/Checkmarx/kics/pkg/descriptions/mock"
	"github.com/Checkmarx/kics/test"
	"github.com/stretchr/testify/require"
)

func TestRequestAndOverrideDescriptions_NoBaseURL(t *testing.T) {
	mock := test.SummaryMock
	descClient = &mock_client.MockDecriptionsClient{}
	mock_client.GetDescriptions = func(descriptionIDs []string) (map[string]string, error) {
		return map[string]string{
			"504b1d43": "my mocked description",
		}, nil
	}
	err := RequestAndOverrideDescriptions(&mock)
	require.NoError(t, err, "Expected error")
	for _, query := range mock.Queries {
		if query.DescriptionID == "504b1d43" {
			require.Equal(t, "my mocked description", query.Description, "Expected description to be overridden")
		}
	}
}
