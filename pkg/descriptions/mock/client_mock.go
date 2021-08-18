package mockclient

import (
	"net/http"

	"github.com/Checkmarx/kics/pkg/descriptions/model"
)

// MockHTTPClient - the mock http client
type MockHTTPClient struct {
	DoFunc func(req *http.Request) (*http.Response, error)
}

// Do - mock clients do function
func (m *MockHTTPClient) Do(req *http.Request) (*http.Response, error) {
	return GetDoFunc(req)
}

// MockDecriptionsClient - the mock CIS descriptions client
type MockDecriptionsClient struct {
	RequestDescriptionsFunc func(descriptionIDs []string) (map[string]model.CISDescriptions, error)
}

// RequestDescriptions - mock descriptions client request descriptions function
func (m *MockDecriptionsClient) RequestDescriptions(descriptionIDs []string) (map[string]model.CISDescriptions, error) {
	return GetDescriptions(descriptionIDs)
}

// CheckConnection - mock CIS descriptions client check connection function
func (m *MockDecriptionsClient) CheckConnection() error {
	return CheckConnection()
}

var (
	// GetDoFunc - mock client's `Do` func
	GetDoFunc func(req *http.Request) (*http.Response, error)
	// CheckConnection - mock client's `CheckConnection` func
	CheckConnection func() error
	// GetDescriptions - mock client's `RequestDescriptions` func
	GetDescriptions func(descriptionIDs []string) (map[string]model.CISDescriptions, error)
)

// MockRequestBody - mock request body
type MockRequestBody struct {
	Descriptions []string `json:"descriptions"`
}

// MockResponseBody - mock response body
type MockResponseBody struct {
	Descriptions map[string]string `json:"descriptions"`
}
