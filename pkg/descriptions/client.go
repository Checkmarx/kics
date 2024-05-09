package descriptions

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"time"

	"github.com/Checkmarx/kics/v2/internal/constants"
	descModel "github.com/Checkmarx/kics/v2/pkg/descriptions/model"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/rs/zerolog/log"
)

var (
	// ***************************************************
	// *  HARDCODED authKey is NOT FOR SECURITY PURPOSES *
	// ***************************************************
	authKey = []rune{67, 101, 110, 116, 101, 114, 95, 102, 111, 114, 95, 73, 110, 116, 101, 114, 110, 101,
		116, 95, 83, 101, 99, 117, 114, 105, 116, 121, 95, 80, 114, 111, 112, 114, 105, 101, 116, 97, 114, 121,
		95, 67, 111, 110, 116, 101, 110, 116, 95, 99, 105, 115, 101, 99, 117, 114, 105, 116, 121, 46, 111, 114, 103}

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
type HTTPDescription interface {
	CheckConnection() error
	RequestDescriptions(descriptionIDs []string) (map[string]descModel.CISDescriptions, error)
	CheckLatestVersion(version string) (model.Version, error)
}

// Client - client for making descriptions requests
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
	defer func() {
		if closeErr := resp.Body.Close(); closeErr != nil {
			log.Err(closeErr).Msg("Error closing file")
		}
	}()
	return err
}

// CheckLatestVersion - Check if using KICS latest version from endpoint
func (c *Client) CheckLatestVersion(version string) (model.Version, error) {
	baseURL, err := getBaseURL()
	if err != nil {
		return model.Version{}, err
	}
	endpointURL := fmt.Sprintf("%s/api/%s", baseURL, "version")

	versionRequest := descModel.VersionRequest{
		Version: version,
	}

	requestBody, err := json.Marshal(versionRequest)
	if err != nil {
		return model.Version{}, err
	}

	req, err := http.NewRequest(http.MethodPost, endpointURL, bytes.NewReader(requestBody)) //nolint
	if err != nil {
		return model.Version{}, err
	}
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", fmt.Sprintf("Basic %s", base64.StdEncoding.EncodeToString([]byte(getBasicAuth()))))

	resp, err := doRequest(req)
	if err != nil {
		return model.Version{}, err
	}
	defer func() {
		if closeErr := resp.Body.Close(); closeErr != nil {
			log.Err(closeErr).Msg("Error closing file")
		}
	}()

	b, err := io.ReadAll(resp.Body)
	if err != nil {
		return model.Version{}, err
	}

	var VersionResponse model.Version
	err = json.Unmarshal(b, &VersionResponse)
	if err != nil {
		return model.Version{}, err
	}

	return VersionResponse, nil
}

// RequestDescriptions - gets descriptions from endpoint
func (c *Client) RequestDescriptions(descriptionIDs []string) (map[string]descModel.CISDescriptions, error) {
	baseURL, err := getBaseURL()
	if err != nil {
		log.Debug().Msg("Unable to get baseURL")
		return nil, err
	}

	endpointURL := fmt.Sprintf("%s/api/%s", baseURL, "descriptions")

	descriptionRequest := descModel.DescriptionRequest{
		Version:        constants.Version,
		DescriptionIDs: descriptionIDs,
	}

	requestBody, err := json.Marshal(descriptionRequest)
	if err != nil {
		log.Err(err).Msg("Unable to marshal request body")
		return nil, err
	}

	req, err := http.NewRequest(http.MethodPost, endpointURL, bytes.NewReader(requestBody)) //nolint
	if err != nil {
		return nil, err
	}
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", fmt.Sprintf("Basic %s", base64.StdEncoding.EncodeToString([]byte(getBasicAuth()))))

	log.Debug().Msgf("HTTP POST to descriptions endpoint")
	startTime := time.Now()
	resp, err := doRequest(req)
	if err != nil {
		log.Err(err).Msgf("Unable to POST to descriptions endpoint")
		return nil, err
	}
	defer func() {
		if closeErr := resp.Body.Close(); closeErr != nil {
			log.Err(closeErr).Msg("Error closing file")
		}
	}()
	endTime := time.Since(startTime)
	log.Debug().Msgf("HTTP Status: %d %s %v", resp.StatusCode, http.StatusText(resp.StatusCode), endTime)

	b, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Err(err).Msg("Unable to read response body")
		return nil, err
	}

	var getDescriptionsResponse descModel.DescriptionResponse
	err = json.Unmarshal(b, &getDescriptionsResponse)
	if err != nil {
		log.Err(err).Msg("Unable to unmarshal response body")
		return nil, err
	}

	return getDescriptionsResponse.Descriptions, nil
}

// doRequest - make HTTP request
func doRequest(request *http.Request) (*http.Response, error) {
	return HTTPRequestClient.Do(request)
}

func getBaseURL() (string, error) {
	var rtnBaseURL string
	urlFromEnv := os.Getenv("KICS_DESCRIPTIONS_ENDPOINT")
	if constants.BaseURL == "" && urlFromEnv == "" {
		return "", fmt.Errorf("the BaseURL or KICS_DESCRIPTIONS_ENDPOINT environment variable not set")
	}

	if urlFromEnv != "" {
		rtnBaseURL = urlFromEnv
	} else {
		rtnBaseURL = constants.BaseURL
	}
	return rtnBaseURL, nil
}

func getBasicAuth() string {
	auth := os.Getenv("KICS_BASIC_AUTH_PASS")
	if auth == "" {
		auth = string(authKey)
	}
	return auth
}
