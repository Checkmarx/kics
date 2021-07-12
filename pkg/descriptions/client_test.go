package descriptions

import (
	"bytes"
	"io/ioutil"
	"net/http"
	"os"
	"testing"

	mockclient "github.com/Checkmarx/kics/pkg/descriptions/mock"
	"github.com/stretchr/testify/require"
)

var (
	responseJSON = `{"descriptions": {"foo1": "bar1", "foo2": "bar2"}}`
)

func TestClient_RequestDescriptions(t *testing.T) {
	os.Setenv("KICS_DESCRIPTIONS_ENDPOINT", "http://example.com")
	HTTPRequestClient = &mockclient.MockHTTPClient{}
	mockclient.GetDoFunc = func(*http.Request) (*http.Response, error) {
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
	headers := http.Header{
		"Content-Type": []string{"application/json"},
	}
	requestBody := mockclient.MockRequestBody{
		Descriptions: []string{
			"foo1",
			"foo2",
			"foo3",
		},
	}
	response, err := post("http://example.com", requestBody, headers)
	require.NoError(t, err, "post() should not return an error")
	defer response.Body.Close()
	require.NotNil(t, response, "post() should return a response")
	require.Equal(t, 200, response.StatusCode, "post() should return a 200 response")
}
