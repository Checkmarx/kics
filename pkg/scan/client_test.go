package scan

import (
	"io"
	"net/http"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/Checkmarx/kics/v2/internal/tracker"
)

func Test_Client(t *testing.T) {
	params := &Parameters{
		PreviewLines:   3,
		ExcludeResults: []string{},
	}

	client, err := NewClient(params, nil, nil)

	require.NotNil(t, client)
	require.NoError(t, err)
}

func Test_ClientError(t *testing.T) {
	params := &Parameters{
		PreviewLines:   0,
		ExcludeResults: []string{},
	}

	client, err := NewClient(params, nil, nil)

	require.Nil(t, client)
	require.Error(t, err)
}

type fakeVersionRoundTripper struct {
	statusCode int
	body       string
}

func (f *fakeVersionRoundTripper) RoundTrip(_ *http.Request) (*http.Response, error) {
	return &http.Response{
		StatusCode: f.statusCode,
		Body:       io.NopCloser(strings.NewReader(f.body)),
		Header:     make(http.Header),
	}, nil
}

func Test_CheckVersion(t *testing.T) {
	tests := []struct {
		name              string
		currentVersion    string
		releaseBody       string
		expectedLatest    bool
		expectedLatestTag string
	}{
		{
			name:              "outdated version compared to v-prefixed GitHub release tag",
			currentVersion:    "2.1.20",
			releaseBody:       `{"tag_name": "v2.1.21"}`,
			expectedLatest:    false,
			expectedLatestTag: "2.1.21",
		},
		{
			name:              "already on the latest version",
			currentVersion:    "2.1.21",
			releaseBody:       `{"tag_name": "v2.1.21"}`,
			expectedLatest:    true,
			expectedLatestTag: "2.1.21",
		},
	}

	originalClient := versionHTTPClient
	originalVersion := constants.Version
	defer func() {
		versionHTTPClient = originalClient
		constants.Version = originalVersion
	}()

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			constants.Version = tt.currentVersion
			versionHTTPClient = &http.Client{
				Transport: &fakeVersionRoundTripper{statusCode: http.StatusOK, body: tt.releaseBody},
			}

			tr, err := tracker.NewTracker(3)
			require.NoError(t, err)

			CheckVersion(tr)

			require.Equal(t, tt.expectedLatestTag, tr.Version.LatestVersionTag)
			require.Equal(t, tt.expectedLatest, tr.Version.Latest)
		})
	}
}
