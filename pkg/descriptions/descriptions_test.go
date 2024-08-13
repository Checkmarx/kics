/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package descriptions

import (
	"os"
	"testing"

	mockclient "github.com/Checkmarx/kics/pkg/descriptions/mock"
	"github.com/Checkmarx/kics/pkg/descriptions/model"
	"github.com/Checkmarx/kics/test"
	"github.com/stretchr/testify/require"
)

func TestRequestAndOverrideDescriptions_NoBaseURL(t *testing.T) {
	mock := test.SummaryMock
	descClient = &mockclient.MockDescriptionsClient{}
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
			require.Equal(t, "my title", query.CISDescriptionTitle, "Expected description to be equal")
		}
	}
}

func Test_CheckConnection(t *testing.T) {
	tests := []struct {
		name          string
		setVar        bool
		varValue      string
		expectedError bool
	}{
		{
			name:          "no env var set",
			setVar:        false,
			expectedError: true,
		},
		{
			name:          "dummy env var set",
			setVar:        true,
			varValue:      "http://example.com",
			expectedError: false,
		},
		{
			name:          "valid env var set",
			setVar:        true,
			varValue:      "http://kics.io",
			expectedError: false,
		},
	}

	envVarName := "KICS_DESCRIPTIONS_ENDPOINT"

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			os.Unsetenv(envVarName)
			if tt.setVar {
				os.Setenv(envVarName, tt.varValue)
			}
			c := Client{}
			err := c.CheckConnection()
			if tt.expectedError {
				require.Error(t, err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}
