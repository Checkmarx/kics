package mockclient

import (
	"net/http"

	"github.com/Checkmarx/kics/pkg/telemetry/model"

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

// MockTelemetryClient - the mock telemetry client
type MockTelemetryClient struct {
	MetricsRequestFunc func() error
}

// RequestDescriptions - mock descriptions/telemetry client request descriptions function
func (m *MockTelemetryClient) RequestDescriptions(descriptionIDs []string) (map[string]model.Descriptions, error) {
	return GetDescriptions(descriptionIDs)
}

// CheckConnection - mock telemetry client check connection function
func (m *MockTelemetryClient) CheckConnection() error {
	return CheckConnection()
}

// CheckLatestVersion - mock client request version function
func (m *MockTelemetryClient) CheckLatestVersion(version string) (genModel.Version, error) {
	return CheckVersion(version)
}

var (
	// GetDoFunc - mock client's `Do` func
	GetDoFunc func(req *http.Request) (*http.Response, error)
	// GetDescriptions - mock client's `RequestDescriptions` func
	GetDescriptions func(descriptionIDs []string) (map[string]model.Descriptions, error)
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
