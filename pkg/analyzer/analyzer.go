package analyzer

import (
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"sync"

	"github.com/Checkmarx/kics/internal/metrics"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

// openAPIRegex - Regex that finds OpenAPI defining property "openapi"
// openAPIRegexInfo - Regex that finds OpenAPI defining property "info"
// openAPIRegexPath - Regex that finds OpenAPI defining property "paths"
// cloudRegex - Regex that finds Cloud Formation defining property "Resources"
// k8sRegex - Regex that finds Kubernetes defining property "apiVersion"
// k8sRegexKind - Regex that finds Kubernetes defining property "kind"
// k8sRegexMetadata - Regex that finds Kubernetes defining property "metadata"
// k8sRegexSpec - Regex that finds Kubernetes defining property "spec"
var (
	openAPIRegex     = regexp.MustCompile("(\\s*\"openapi\":)|(\\s*openapi:)")
	openAPIRegexInfo = regexp.MustCompile("(\\s*\"info\":)|(\\s*info:)")
	openAPIRegexPath = regexp.MustCompile("(\\s*\"paths\":)|(\\s*paths:)")
	cloudRegex       = regexp.MustCompile("(\\s*\"Resources\":)|(\\s*Resources:)")
	k8sRegex         = regexp.MustCompile("(\\s*\"apiVersion\":)|(\\s*apiVersion:)")
	k8sRegexKind     = regexp.MustCompile("(\\s*\"kind\":)|(\\s*kind:)")
	k8sRegexMetadata = regexp.MustCompile("(\\s*\"metadata\":)|(\\s*metadata:)")
	k8sRegexSpec     = regexp.MustCompile("(\\s*\"spec\":)|(\\s*spec:)")
)

const (
	yml  = ".yml"
	yaml = ".yaml"
)

// Analyze will go through the paths given and determine what type of queries to load
// based on the extension of the file and the content
func Analyze(paths []string) ([]string, error) {
	// start metrics for file analyzer
	metrics.Metric.Start("file_type_analyzer")

	availableTypes := make([]string, 0)
	var files []string
	var wg sync.WaitGroup
	// results is the channel shared by the workers that contains the types found
	results := make(chan string)

	// get all the files inside the given paths
	for _, path := range paths {
		if _, err := os.Stat(path); err != nil {
			return []string{}, errors.Wrap(err, "failed to analyze path")
		}
		if err := filepath.Walk(path, func(path string, info os.FileInfo, err error) error {
			if !info.IsDir() {
				files = append(files, path)
			}
			return nil
		}); err != nil {
			log.Error().Msgf("failed to analize path %s: %s", path, err)
		}
	}

	for _, file := range files {
		wg.Add(1)
		// analyze the files concurrently
		go worker(file, results, &wg)
	}

	go func() {
		// close channel results when worker has finished writing into it
		defer close(results)
		wg.Wait()
	}()

	for i := range results {
		// read channel results and if type received is not in return slice
		// add it
		if !contains(availableTypes, i) {
			availableTypes = append(availableTypes, i)
		}
	}
	// stop metrics for file analyzer
	metrics.Metric.Stop()
	return availableTypes, nil
}

// worker determines the type of the file by ext (dockerfile and terraform)/content and
// writes the answer to the results channel
func worker(path string, results chan<- string, wg *sync.WaitGroup) {
	defer wg.Done()
	ext := filepath.Ext(path)
	if ext == "" {
		ext = filepath.Base(path)
	}
	switch ext {
	// Dockerfile
	case ".dockerfile", "Dockerfile":
		results <- "dockerfile"
	// Terraform
	case ".tf":
		results <- "terraform"
	// Cloud Formation, Ansible, OpenAPI
	case yaml, yml, ".json":
		checkContent(path, results, ext)
	}
}

// regexSlice is a struct to contain a slice of regex
type regexSlice struct {
	regex []*regexp.Regexp
}

// types is a map that contains the regex by type
var types = map[string]regexSlice{
	"openapi": {
		regex: []*regexp.Regexp{
			openAPIRegex,
			openAPIRegexInfo,
			openAPIRegexPath,
		},
	},
	"kubernetes": {
		regex: []*regexp.Regexp{
			k8sRegex,
			k8sRegexKind,
			k8sRegexMetadata,
			k8sRegexSpec,
		},
	},
	"cloudformation": {
		regex: []*regexp.Regexp{
			cloudRegex,
		},
	},
}

// checkContent will determine the file type by content when worker was unable to
// determine by ext
func checkContent(path string, results chan<- string, ext string) {
	// get file content
	content, err := os.ReadFile(path)
	if err != nil {
		log.Error().Msgf("failed to analyze file: %s", err)
	}

	returnType := ""

	// Sort map so that CloudFormation (type that as less requireds) goes last
	keys := make([]string, 0, len(types))
	for k := range types {
		keys = append(keys, k)
	}

	sort.Sort(sort.Reverse(sort.StringSlice(keys)))

	for _, key := range keys {
		check := true
		for _, typeRegex := range types[key].regex {
			if res := typeRegex.Match(content); !res {
				check = false
				break
			}
		}
		// If all regexs passed and there wasn't a type already assigned
		if check && returnType == "" {
			returnType = key
		}
	}

	if returnType != "" {
		// write to channel type of file
		results <- returnType
	} else if ext == yaml || ext == yml {
		// Since Ansible as no defining property
		// and no other type was found for YAML assume its Ansible
		results <- "ansible"
	}
}

// contains is a simple method to check if a slice
// contains an entry
func contains(s []string, e string) bool {
	for _, a := range s {
		if a == e {
			return true
		}
	}
	return false
}
