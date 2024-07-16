package descriptions

import (
	"bytes"
	"encoding/json"
	"io/ioutil"
	"net/http"
	"os"
	"testing"

	mockclient "github.com/Checkmarx/kics/v2/pkg/descriptions/mock"
	"github.com/stretchr/testify/require"
)

var (
	responseJSON = `{
		"descriptions": {
			"foo1": {
				"cisDescriptionText": "",
				"cisDescriptionID": "",
				"cisDescriptionRuleID": "",
				"cisDescriptionTitle": "",
				"cisRationaleText": "",
				"cisBenchmarkName": "",
				"cisBenchmarkVersion": ""
			},
			"foo2": {
				"cisDescriptionText": "",
				"cisDescriptionID": "",
				"cisDescriptionRuleID": "",
				"cisDescriptionTitle": "",
				"cisRationaleText": "",
				"cisBenchmarkName": "",
				"cisBenchmarkVersion": ""
			}
		}
	}`
)

func TestClient_RequestDescriptions(t *testing.T) {
	os.Setenv("KICS_DESCRIPTIONS_ENDPOINT", "http://example.com")
	HTTPRequestClient = &mockclient.MockHTTPClient{}
	mockclient.GetDoFunc = func(request *http.Request) (*http.Response, error) {
		if request.Method == http.MethodGet {
			r := ioutil.NopCloser(bytes.NewReader([]byte("KICS DESCRIPTIONS API")))
			return &http.Response{
				StatusCode: 200,
				Body:       r,
			}, nil
		}

		r := ioutil.NopCloser(bytes.NewReader([]byte(responseJSON)))
		return &http.Response{
			StatusCode: 200,
			Body:       r,
		}, nil
	}
	descClient := Client{}
	descriptions, err := descClient.RequestDescriptions([]string{
		"foo1",
		"foo2",
		"foo3",
	})
	require.NoError(t, err, "RequestDescriptions() should not return an error")
	require.NotNil(t, descriptions, "RequestDescriptions() should return a description map")
	t.Cleanup(func() {
		os.Setenv("KICS_DESCRIPTIONS_ENDPOINT", "")
	})
}

func TestClient_post(t *testing.T) {
	HTTPRequestClient = &mockclient.MockHTTPClient{}
	mockclient.GetDoFunc = func(*http.Request) (*http.Response, error) {
		r := ioutil.NopCloser(bytes.NewReader([]byte(responseJSON)))
		return &http.Response{
			StatusCode: 200,
			Body:       r,
		}, nil
	}
	headers := map[string]string{
		"Content-Type": "application/json",
	}
	requestBody := mockclient.MockRequestBody{
		Descriptions: []string{
			"foo1",
			"foo2",
			"foo3",
		},
	}

	jsonBytes, err := json.Marshal(requestBody)
	require.NoError(t, err, "Marshaling request body should not return an error")

	request, err := http.NewRequest(http.MethodPost, "http://example.com", bytes.NewReader(jsonBytes))
	require.NoError(t, err, "Creating request should not return an error")

	for key, value := range headers {
		request.Header.Add(key, value)
	}
	response, err := doRequest(request)
	require.NoError(t, err, "post() should not return an error")
	defer response.Body.Close()
	require.NotNil(t, response, "post() should return a response")
	require.Equal(t, 200, response.StatusCode, "post() should return a 200 response")
}

func TestClient_CheckLatestVersion(t *testing.T) {
	os.Setenv("KICS_DESCRIPTIONS_ENDPOINT", "http://example.com")
	HTTPRequestClient = &mockclient.MockHTTPClient{}
	mockclient.GetDoFunc = func(request *http.Request) (*http.Response, error) {
		if request.Method == http.MethodGet {
			r := ioutil.NopCloser(bytes.NewReader([]byte("KICS DESCRIPTIONS API")))
			return &http.Response{
				StatusCode: 200,
				Body:       r,
			}, nil
		}

		r := ioutil.NopCloser(bytes.NewReader([]byte(responseJSON)))
		return &http.Response{
			StatusCode: 200,
			Body:       r,
		}, nil
	}
	descClient := Client{}
	version, err := descClient.CheckLatestVersion("1.4.0")
	require.NoError(t, err, "CheckLatestVersion() should not return an error")
	require.NotNil(t, version, "CheckLatestVersion() should return a version check")
	t.Cleanup(func() {
		os.Setenv("KICS_DESCRIPTIONS_ENDPOINT", "")
	})
}
