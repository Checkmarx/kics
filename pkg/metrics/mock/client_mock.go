package mockclient

import (
	"net/http"

	genModel "github.com/Checkmarx/kics/pkg/model"
)

// MockHTTPClient - the mock http client
type MockHTTPClient struct {
	DoFunc func(req *http.Request) (*http.Response, error)
}

// Do - mock clients do function
func (m *MockHTTPClient) Do(req *http.Request) (*http.Response, error) {
	return GetDoFunc(req)
}

// MockMetricsClient - the mock metrics client
type MockMetricsClient struct {
	MetricsRequestFunc func() error
}

// CheckLatestVersion - mock client request version function
func (m *MockMetricsClient) CheckLatestVersion(version string) (genModel.Version, error) {
	return CheckVersion(version)
}

var (
	// GetDoFunc - mock client's `Do` func
	GetDoFunc func(req *http.Request) (*http.Response, error)
	// CheckConnection - mock client's `CheckConnection` func
	CheckConnection func() error
	// CheckVersion mock client's `CheckLatestVersion` func
	CheckVersion func(version string) (genModel.Version, error)
)

// MockRequestBody - mock request body
type MockRequestBody struct {
	Descriptions []string `json:"descriptions"`
}

// MockResponseBody - mock response body
type MockResponseBody struct {
	Descriptions map[string]string `json:"descriptions"`
}
