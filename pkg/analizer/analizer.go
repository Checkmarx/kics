package analizer

import (
	"os"
	"path/filepath"
	"regexp"
	"sync"

	"github.com/Checkmarx/kics/internal/metrics"
	"github.com/rs/zerolog/log"
)

var (
	openAPIRegex = regexp.MustCompile("(\\s*\"openapi\":)|(\\s*openapi:)")
	cloudRegex   = regexp.MustCompile("(\\s*\"Resources\":)|(\\s*Resources:)")
	k8sRegex     = regexp.MustCompile("(\\s*\"apiVersion\":)|(\\s*apiVersion:)")
)

const (
	yml  = ".yml"
	yaml = ".yaml"
)

func Analize(paths []string) []string {
	metrics.Metric.Start("file_type_analizer")
	var files []string
	var wg sync.WaitGroup
	results := make(chan string)

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
		go worker(file, results, &wg)
	}

	go func() {
		defer close(results)
		wg.Wait()
	}()

	availableTypes := make([]string, 0)
	for i := range results {
		if !contains(availableTypes, i) {
			availableTypes = append(availableTypes, i)
		}
	}
	metrics.Metric.Stop()
	return availableTypes
}

func worker(path string, results chan<- string, wg *sync.WaitGroup) {
	defer wg.Done()
	ext := filepath.Ext(path)
	if ext == "" {
		ext = filepath.Base(path)
	}
	switch ext {
	case ".dockerfile", "Dockerfile":
		results <- "dockerfile"
	case ".tf":
		results <- "terraform"
	case yaml, yml, ".json":
		checkContent(path, results, ext)
	}
}

func checkContent(path string, results chan<- string, ext string) {
	content, err := os.ReadFile(path)
	if err != nil {
		log.Error().Msgf("failed to analyze file: %s", err)
	}

	if openAPIRegex.Match(content) {
		results <- "openapi"
		return
	}
	if cloudRegex.Match(content) {
		results <- "cloudformation"
		return
	}
	if k8sRegex.Match(content) {
		results <- "kubernetes"
		return
	}
	if ext == yaml || ext == yml {
		results <- "ansible"
		return
	}
}

func contains(s []string, e string) bool {
	for _, a := range s {
		if a == e {
			return true
		}
	}
	return false
}
