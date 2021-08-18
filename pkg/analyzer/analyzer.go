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
	openAPIRegex           = regexp.MustCompile("(\\s*\"openapi\":)|(\\s*openapi:)|(\\s*\"swagger\":)|(\\s*swagger:)")
	openAPIRegexInfo       = regexp.MustCompile("(\\s*\"info\":)|(\\s*info:)")
	openAPIRegexPath       = regexp.MustCompile("(\\s*\"paths\":)|(\\s*paths:)")
	armRegexContentVersion = regexp.MustCompile("\\s*\"contentVersion\":")
	armRegexResources      = regexp.MustCompile("\\s*\"resources\":")
	cloudRegex             = regexp.MustCompile("(\\s*\"Resources\":)|(\\s*Resources:)")
	k8sRegex               = regexp.MustCompile("(\\s*\"apiVersion\":)|(\\s*apiVersion:)")
	k8sRegexKind           = regexp.MustCompile("(\\s*\"kind\":)|(\\s*kind:)")
	k8sRegexMetadata       = regexp.MustCompile("(\\s*\"metadata\":)|(\\s*metadata:)")
)

const (
	yml  = ".yml"
	yaml = ".yaml"
)

// Analyze will go through the slice paths given and determine what type of queries should be loaded
// should be loaded based on the extension of the file and the content
func Analyze(paths []string) (typesRes, excludeRes []string, errRes error) {
	// start metrics for file analyzer
	metrics.Metric.Start("file_type_analyzer")

	var files []string
	var wg sync.WaitGroup
	// results is the channel shared by the workers that contains the types found
	results := make(chan string)

	// get all the files inside the given paths
	for _, path := range paths {
		if _, err := os.Stat(path); err != nil {
			return []string{}, []string{}, errors.Wrap(err, "failed to analyze path")
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

	// unwanted is the channel shared by the workers that contains the unwanted files that the parser will ignore
	unwanted := make(chan string, len(files))

	for _, file := range files {
		wg.Add(1)
		// analyze the files concurrently
		go worker(file, results, unwanted, &wg)
	}

	go func() {
		// close channel results when the worker has finished writing into it
		defer func() {
			close(unwanted)
			close(results)
		}()
		wg.Wait()
	}()

	availableTypes := createSlice(results)
	unwantedPaths := createSlice(unwanted)

	// stop metrics for file analyzer
	metrics.Metric.Stop()
	return availableTypes, unwantedPaths, nil
}

// worker determines the type of the file by ext (dockerfile and terraform)/content and
// writes the answer to the results channel
// if no types were found, the worker will write the path of the file in the unwanted channel
func worker(path string, results, unwanted chan<- string, wg *sync.WaitGroup) {
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
		checkContent(path, results, unwanted, ext)
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
		},
	},
	"cloudformation": {
		regex: []*regexp.Regexp{
			cloudRegex,
		},
	},
	"azureresourcemanager": {
		[]*regexp.Regexp{
			armRegexContentVersion,
			armRegexResources,
		},
	},
}

// checkContent will determine the file type by content when worker was unable to
// determine by ext, if no type was determined checkContent adds it to unwanted channel
func checkContent(path string, results, unwanted chan<- string, ext string) {
	// get file content
	content, err := os.ReadFile(path)
	if err != nil {
		log.Error().Msgf("failed to analyze file: %s", err)
		return
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
		// Since Ansible has no defining property
		// and no other type matched for YAML file extension, assume the file type is Ansible
		results <- "ansible"
	} else {
		// No type was determined (ignore on parser)
		unwanted <- path
	}
}

// createSlice creates a slice from the channel given removing any duplicates
func createSlice(chanel chan string) []string {
	slice := make([]string, 0)
	for i := range chanel {
		if !contains(slice, i) {
			slice = append(slice, i)
		}
	}
	return slice
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
