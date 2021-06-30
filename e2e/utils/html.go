package utils

import (
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"
	"golang.org/x/net/html"
)

func HTMLValidation(t *testing.T, file string) {
	availableCategories := map[string]string{
		"Access Control":          "CAT001",
		"Availability":            "CAT002",
		"Backup":                  "CAT003",
		"Best Practices":          "CAT004",
		"Build Process":           "CAT005",
		"Encryption":              "CAT006",
		"Insecure Configurations": "CAT007",
		"Insecure Defaults":       "CAT008",
		"Networking and Firewall": "CAT009",
		"Observability":           "CAT010",
		"Resource Management":     "CAT011",
		"Secret Management":       "CAT012",
		"Supply-Chain":            "CAT013",
		"Structure and Semantics": "CAT014",
	}

	availablePlatforms := map[string]string{
		"Ansible":        "ansible",
		"CloudFormation": "cloudFormation",
		"Common":         "common",
		"Dockerfile":     "dockerfile",
		"Kubernetes":     "k8s",
		"OpenAPI":        "openAPI",
		"Terraform":      "terraform",
	}

	// Read & Parse Expected HTML Report
	expectHTMLString, err := os.ReadFile(filepath.Join("fixtures", file))
	require.NoError(t, err)
	expectedHTML, err := html.Parse(strings.NewReader(string(expectHTMLString)))
	require.NoError(t, err)

	// Read & Parse Output HTML Report
	actualHTMLString, err := os.ReadFile(filepath.Join("output", file))
	require.NoError(t, err)
	actualHTML, err := html.Parse(strings.NewReader(string(actualHTMLString)))
	require.NoError(t, err)

	// Compare Header Data (Paths, Platforms)
	headerIds := []string{"scan-paths", "scan-platforms"}
	for arg := range headerIds {
		expectedValue := getElementByID(expectedHTML, headerIds[arg]).LastChild.Data
		actualValue := getElementByID(actualHTML, headerIds[arg]).LastChild.Data

		require.Equal(t, expectedValue, actualValue,
			"[HTML Report] HTML Element <%s>:\n- Expected value: %s\n- Actual value: %s\n", headerIds[arg], expectedValue, actualValue)
	}

	// Compare Severity Values (High, Medium, Total...)
	severityIds := []string{"info", "low", "medium", "high", "total"}
	for arg := range severityIds {
		nodeIdentificator := "severity-count-" + severityIds[arg]
		expectedSeverityValue := getElementByID(expectedHTML, nodeIdentificator).FirstChild.Data
		actualSeverityValue := getElementByID(actualHTML, nodeIdentificator).FirstChild.Data

		require.Equal(t, expectedSeverityValue, actualSeverityValue,
			"[HTML Report] HTML Element <%s>:\n- Expected value: %s\n- Actual value: %s\n",
			nodeIdentificator, expectedSeverityValue, actualSeverityValue)

		classIdentificator := "severity-partial-count-" + severityIds[arg]
		expectedSeverityClassValues := getAndSumElementsByClass(expectedHTML, classIdentificator)
		actualSeverityClassValues := getAndSumElementsByClass(actualHTML, classIdentificator)

		require.Equal(t, expectedSeverityClassValues, actualSeverityClassValues,
			"[HTML Report] Expected Sum of HTML classes <%s>:\n- Expected Value: %d\n- Actual value: %d\n",
			classIdentificator, expectedSeverityClassValues, actualSeverityClassValues)
	}

	// Validate Query Names
	for _, node := range getElementsByClass(actualHTML, "query-name") {
		require.NotNil(t, node.FirstChild,
			"[HTML Report] Invalid query in class element < query-info-platform >")
	}

	// Validate Platforms
	for _, node := range getElementsByClass(actualHTML, "query-info-platform") {
		require.NotNil(t, node.FirstChild,
			"[HTML Report] Invalid plataform in class element < query-info-platform >")

		require.NotEmpty(t, availablePlatforms[node.FirstChild.Data],
			"[HTML Report] Invalid plataform in class element < query-info-platform >: %s\n", node.FirstChild.Data)
	}

	// Validate Categories
	for _, node := range getElementsByClass(actualHTML, "query-info-category") {
		require.NotNil(t, node.FirstChild,
			"[HTML Report] Invalid category in class element < query-info-category >")

		require.NotEmpty(t, availableCategories[node.FirstChild.Data],
			"[HTML Report] Invalid category in class element < query-info-category >: %s\n", node.FirstChild.Data)
	}
}

func findAttribute(node *html.Node, key string) (string, bool) {
	for _, attr := range node.Attr {
		if attr.Key == key {
			return attr.Val, true
		}
	}
	return "", false
}

func existsAttribute(node *html.Node, name, tag string) bool {
	if node.Type == html.ElementNode {
		value, exists := findAttribute(node, tag)
		if exists && value == name {
			return true
		}
	}
	return false
}

func getElementByID(n *html.Node, name string) *html.Node {
	response := n

	var f func(node *html.Node, name string)
	f = func(node *html.Node, name string) {
		if existsAttribute(node, name, "id") {
			response = node
		}
		for c := node.FirstChild; c != nil; c = c.NextSibling {
			f(c, name)
		}
	}

	f(n, name)

	return response
}

func getElementsByClass(n *html.Node, name string) []*html.Node {
	classNodes := []*html.Node{}

	var f func(node *html.Node, name string)
	f = func(node *html.Node, name string) {
		if existsAttribute(node, name, "class") {
			classNodes = append(classNodes, node)
		}
		for c := node.FirstChild; c != nil; c = c.NextSibling {
			f(c, name)
		}
	}

	f(n, name)

	return classNodes
}

func getAndSumElementsByClass(n *html.Node, name string) int {
	classes := getElementsByClass(n, name)
	result := 0

	for i := range classes {
		classValue, err := strconv.Atoi(classes[i].FirstChild.Data)
		if err == nil {
			result += classValue
		}
	}

	return result
}
