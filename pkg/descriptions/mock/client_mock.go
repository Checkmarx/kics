package mockclient

import (
	"net/http"
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
	RequestDescriptionsFunc func(descriptionIDs []string) (map[string]string, error)
}

// RequestDescriptions - mock descriptiosn client request descriptions function
func (m *MockDecriptionsClient) RequestDescriptions(descriptionIDs []string) (map[string]string, error) {
	return GetDescriptions(descriptionIDs)
}

var (
	// GetDoFunc - mock client's `Do` func
	GetDoFunc func(req *http.Request) (*http.Response, error)
	// GetDescriptions - mock client's `RequestDescriptions` func
	GetDescriptions func(descriptionIDs []string) (map[string]string, error)
)

// MockRequestBody - mock request body
type MockRequestBody struct {
	Descriptions []string `json:"descriptions"`
}

// MockResponseBody - mock response body
type MockResponseBody struct {
	Descriptions map[string]string `json:"descriptions"`
}
