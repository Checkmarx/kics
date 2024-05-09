package mockclient

import (
	"net/http"

	"github.com/Checkmarx/kics/v2/pkg/descriptions/model"
	genModel "github.com/Checkmarx/kics/v2/pkg/model"
)

// MockHTTPClient - the mock http client
type MockHTTPClient struct {
	DoFunc func(req *http.Request) (*http.Response, error)
}

// Do - mock clients do function
func (m *MockHTTPClient) Do(req *http.Request) (*http.Response, error) {
	return GetDoFunc(req)
}

// MockDescriptionsClient - the mock descriptions client
type MockDescriptionsClient struct {
	RequestDescriptionsFunc func(descriptionIDs []string) (map[string]model.CISDescriptions, error)
}

// RequestDescriptions - mock descriptions client request descriptions function
func (m *MockDescriptionsClient) RequestDescriptions(descriptionIDs []string) (map[string]model.CISDescriptions, error) {
	return GetDescriptions(descriptionIDs)
}

// CheckConnection - mock descriptions client check connection function
func (m *MockDescriptionsClient) CheckConnection() error {
	return CheckConnection()
}

// CheckLatestVersion - mock client request version function
func (m *MockDescriptionsClient) CheckLatestVersion(version string) (genModel.Version, error) {
	return CheckVersion(version)
}

var (
	// GetDoFunc - mock client's `Do` func
	GetDoFunc func(req *http.Request) (*http.Response, error)
	// CheckConnection - mock client's `CheckConnection` func
	CheckConnection func() error
	// GetDescriptions - mock client's `RequestDescriptions` func
	GetDescriptions func(descriptionIDs []string) (map[string]model.CISDescriptions, error)
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
