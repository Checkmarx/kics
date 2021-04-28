package analyzer

import (
	"os"
	"path/filepath"
	"regexp"
	"sync"

	"github.com/Checkmarx/kics/internal/metrics"
	"github.com/rs/zerolog/log"
)

// openAPIRegex - Regex that finds OpenAPI defining property
// cloudRegex - Regex that finds Cloud Formation defining property
// k8sRegex - Regex that finds Kubernetes defining property
var (
	openAPIRegex = regexp.MustCompile("(\\s*\"openapi\":)|(\\s*openapi:)")
	cloudRegex   = regexp.MustCompile("(\\s*\"Resources\":)|(\\s*Resources:)")
	k8sRegex     = regexp.MustCompile("(\\s*\"apiVersion\":)|(\\s*apiVersion:)")
)

const (
	yml  = ".yml"
	yaml = ".yaml"
)

// Analyze will go through the paths given and determine what type of queries to load
// based on the extension of the file and the content
func Analyze(paths []string) []string {
	// start metrics for file analyzer
	metrics.Metric.Start("file_type_analyzer")

	availableTypes := make([]string, 0)
	var files []string
	var wg sync.WaitGroup
	// results is the channel shared by the workers that contains the types found
	results := make(chan string)

	// get all the files inside the given paths
	for _, path := range paths {
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
		// close channel results when worker has fineshed writing into it
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
	return availableTypes
}

// worker determines the type of the file by ext (dockerfile and terraform)/content and
// writes the awnser to the results channel
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

// checkContent will determine the file type by content when worker was unable to
// determine by ext
func checkContent(path string, results chan<- string, ext string) {
	// get file content
	content, err := os.ReadFile(path)
	if err != nil {
		log.Error().Msgf("failed to analyze file: %s", err)
	}
	// OpenAPI
	if openAPIRegex.Match(content) {
		results <- "openapi"
		return
	}
	// Cloud Formation
	if cloudRegex.Match(content) {
		results <- "cloudformation"
		return
	}
	// Kubernetes
	if k8sRegex.Match(content) {
		results <- "kubernetes"
		return
	}
	// Since Ansible as no defining property
	// and no other type was found for YAML assume its Ansible
	if ext == yaml || ext == yml {
		results <- "ansible"
		return
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
