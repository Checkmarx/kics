package utils

import (
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"testing"

	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/stretchr/testify/require"
	"golang.org/x/net/html"
)

var (
	availablePlatforms = initPlatforms()
	severityIds        = []string{"info", "low", "medium", "high", "critical", "total"}
	headerIds          = []string{"scan-paths", "scan-platforms"}
)

func initPlatforms() map[string]string {
	platforms := make(map[string]string)
	for k, v := range constants.AvailablePlatforms {
		platforms[k] = v
	}
	platforms["Common"] = "common"
	return platforms
}

// HTMLValidation executes many asserts to validate the HTML Report
func HTMLValidation(t *testing.T, file string) {
	// Read & Parse Expected HTML Report
	expectHTMLString, errExpStr := os.ReadFile(filepath.Clean(filepath.Join("fixtures", file)))
	require.NoError(t, errExpStr, "Opening Expected HTML File should not yield an error")
	expectedHTML, errExp := html.Parse(strings.NewReader(string(expectHTMLString)))
	require.NoError(t, errExp, "Opening Expected HTML File should not yield an error")

	// Read & Parse Output HTML Report
	actualHTMLString, errActStr := os.ReadFile(filepath.Clean(filepath.Join("output", file)))
	require.NoError(t, errActStr, "Opening Actual HTML File should not yield an error")
	actualHTML, errAct := html.Parse(strings.NewReader(string(actualHTMLString)))
	require.NoError(t, errAct, "Opening Actual HTML File should not yield an error")

	// Compare Header Data (Paths, Platforms)
	sliceOfExpected := make([]string, 0, len(headerIds))
	sliceOfActual := make([]string, 0, len(headerIds))
	for _, header := range headerIds {
		expectedValue := getElementByID(expectedHTML, header)
		actualValue := getElementByID(actualHTML, header)
		sliceOfActual = append(sliceOfActual, strings.Split(actualValue.LastChild.Data, ",")...)
		// Adapt path if running locally (dev)
		if GetKICSDockerImageName() == "" {
			expectedValue.LastChild.Data = KicsDevPathAdapter(expectedValue.LastChild.Data)
		}
		sliceOfExpected = append(sliceOfExpected, strings.Split(expectedValue.LastChild.Data, ",")...)
		require.NotNil(t, actualValue.LastChild, "[%s] Invalid value in Element ID <%s>", file, header)
	}

	require.ElementsMatch(t, sliceOfExpected, sliceOfActual,
		"[%s] HTML Element :\n- Expected value: %s\n- Actual value: %s\n",
		file, sliceOfExpected, sliceOfActual)

	for arg := range severityIds {
		nodeIdentifier := "severity-count-" + severityIds[arg]
		expectedSeverityValue := getElementByID(expectedHTML, nodeIdentifier)
		actualSeverityValue := getElementByID(actualHTML, nodeIdentifier)

		require.NotNil(t, actualSeverityValue.FirstChild,
			"[%s] Invalid value in Element ID <%s>", file, nodeIdentifier)

		require.Equal(t, expectedSeverityValue.FirstChild.Data, actualSeverityValue.FirstChild.Data,
			"[%s] HTML Element <%s>:\n- Expected value: %s\n- Actual value: %s\n",
			file, nodeIdentifier, expectedSeverityValue.FirstChild.Data, actualSeverityValue.FirstChild.Data)

		classIdentifier := "severity-partial-count-" + severityIds[arg]
		expectedSeverityClassValues := getAndSumElementsByClass(expectedHTML, classIdentifier)
		actualSeverityClassValues := getAndSumElementsByClass(actualHTML, classIdentifier)

		require.Equal(t, expectedSeverityClassValues, actualSeverityClassValues,
			"[%s] Expected Sum of HTML classes <%s>:\n- Expected Value: %d\n- Actual value: %d\n",
			file, classIdentifier, expectedSeverityClassValues, actualSeverityClassValues)
	}

	// Validate Query Names
	queriesClassname := "query-name"
	queriesClasses := getElementsByClass(actualHTML, queriesClassname)
	for _, node := range queriesClasses {
		require.NotNil(t, node.FirstChild,
			"[%s] Invalid query in class element <%s>", file, queriesClassname)
	}

	// Validate Platforms
	platformClassname := "query-info-platform"
	platformsClasses := getElementsByClass(actualHTML, platformClassname)
	for _, node := range platformsClasses {
		require.NotNil(t, node.FirstChild,
			"[%s] Invalid platform in class element <%s>", file, platformClassname)

		require.NotEmpty(t, availablePlatforms[node.FirstChild.Data],
			"[%s] Invalid platform in class element <%s>: %s\n", file, platformClassname, node.FirstChild.Data)
	}

	// Validate Categories
	categoriesClassname := "query-info-category"
	categoriesClasses := getElementsByClass(actualHTML, categoriesClassname)
	for _, node := range categoriesClasses {
		require.NotNil(t, node.FirstChild,
			"[%s] Invalid category in class element <%s>", file, categoriesClassname)

		require.NotEmpty(t, constants.AvailableCategories[node.FirstChild.Data],
			"[%s] Invalid category in class element <%s>: %s\n", file, categoriesClassname, node.FirstChild.Data)
	}

	// Validate Total Number of Results and Code-Boxes
	totalClassname := "severity-count-total"
	total, err := strconv.Atoi(getElementByID(actualHTML, totalClassname).FirstChild.Data)
	require.NoError(t, err, "Getting Total Results should not yield an error")

	codeBoxClassname := "code-box"
	codeBoxClasses := getElementsByClass(actualHTML, codeBoxClassname)

	require.Equal(t, total, len(codeBoxClasses),
		"[%s] The Value of Element ID <%s> is not equal the number of <%s> classes in the HTML File"+
			"\n- <%s>: %d\n- <%s>: %d\n",
		file, totalClassname, codeBoxClassname, totalClassname, total, codeBoxClassname, len(codeBoxClasses))
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
	var classNodes []*html.Node

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
