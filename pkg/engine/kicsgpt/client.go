package kicsgpt

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"time"

	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/pkg/engine/kicsgpt/model"
	"github.com/rs/zerolog/log"
)

var (
	tr = &http.Transport{
		Proxy:              http.ProxyFromEnvironment,
		MaxIdleConns:       10,
		IdleConnTimeout:    30 * time.Second,
		DisableCompression: true,
	}
	// HTTPRequestClient - http client to use for requests
	HTTPRequestClient HTTPClient = &http.Client{
		Transport: tr,
		Timeout:   20 * time.Second,
	}
)

// HTTPClient - http client to use for requests
type HTTPClient interface {
	Do(req *http.Request) (*http.Response, error)
}

// HTTPDescription - HTTP client interface to use for requesting descriptions
type HTTPKicsGPT interface {
	CheckConnection() error
	RequestEvaluation(fileData string) (model.GPTResponse, error)
}

// Client - client for making CIS descriptions requests
type Client struct {
}

// CheckConnection - checks if the endpoint is reachable
func (c *Client) CheckConnection() error {
	baseURL, err := getBaseURL()
	if err != nil {
		return err
	}

	endpointURL := fmt.Sprintf("%s/api/", baseURL)
	req, err := http.NewRequest(http.MethodGet, endpointURL, http.NoBody) //nolint
	if err != nil {
		return err
	}

	resp, err := doRequest(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	return err
}

// RequestDescriptions - gets CIS descriptions from endpoint
func (c *Client) RequestEvaluation(fileData string) (model.GPTResponse, error) {
	var getGPTCallResponse model.GPTResponse
	baseURL, err := getBaseURL()
	if err != nil {
		log.Debug().Msg("Unable to get baseURL")
		return getGPTCallResponse, err
	}

	endpointURL := fmt.Sprintf("%s/api/%s", baseURL, "getEvaluation")

	gptRequest := model.GPTRequest{
		FileContent: fileData,
	}

	requestBody, err := json.Marshal(gptRequest)
	if err != nil {
		log.Err(err).Msg("Unable to marshal request body")
		return getGPTCallResponse, err
	}

	req, err := http.NewRequest(http.MethodGet, endpointURL, bytes.NewReader(requestBody)) //nolint
	if err != nil {
		return getGPTCallResponse, err
	}
	req.Header.Add("Content-Type", "application/json")
	//req.Header.Add("Authorization", fmt.Sprintf("Basic %s", base64.StdEncoding.EncodeToString([]byte(getBasicAuth()))))

	log.Debug().Msgf("HTTP GET to KicsGPT endpoint")
	startTime := time.Now()
	resp, err := doRequest(req)
	if err != nil {
		log.Err(err).Msgf("Unable to GET to KicsGPT endpoint")
		return getGPTCallResponse, err
	}
	defer resp.Body.Close()
	endTime := time.Since(startTime)
	log.Debug().Msgf("HTTP Status: %d %s %v", resp.StatusCode, http.StatusText(resp.StatusCode), endTime)

	b, err := io.ReadAll(resp.Body)
	if err != nil || len(b) == 0 {
		log.Err(err).Msg("Unable to read response body")
		return getGPTCallResponse, err
	}

	/*stringUnquoted, err := strconv.Unquote("\"" + string(b) + "\"")
	#if err != nil {
		log.Err(err).Msg("Unable to unquote response body")
		return nil, err
	}*/

	err = json.Unmarshal([]byte(b), &getGPTCallResponse.Vulnerabilities)
	if err != nil {
		log.Err(err).Msg("Unable to unmarshal response body")
		return getGPTCallResponse, err
	}

	return getGPTCallResponse, nil
}

// doRequest - make HTTP request
func doRequest(request *http.Request) (*http.Response, error) {
	return HTTPRequestClient.Do(request)
}

func getBaseURL() (string, error) {
	var rtnBaseURL string
	urlFromEnv := os.Getenv("KICS_GPT_ENDPOINT")
	if constants.BaseURL == "" && urlFromEnv == "" {
		return "", fmt.Errorf("the BaseURL or KICS_GPT_ENDPOINT environment variable not set")
	}

	if urlFromEnv != "" {
		rtnBaseURL = urlFromEnv
	} else {
		rtnBaseURL = constants.BaseURL
	}
	return rtnBaseURL, nil
}

/*
func getBasicAuth() string {
	auth := os.Getenv("KICS_BASIC_AUTH_PASS")
	if auth == "" {
		auth = string(authKey)
	}
	return auth
}
*/
