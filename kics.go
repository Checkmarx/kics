package main

import (
	"github.com/Checkmarx/kics/internal/console"
	"github.com/Checkmarx/kics/pkg/scan"
)

func main() {
	inputPaths := []string{
		"/Users/bahar.shah/go/src/github.com/DataDog/innovation-week-cloud-to-tf/terraform/ami.tf",
	}
	outputPath := "/Users/bahar.shah/go/src/github.com/DataDog/innovation-week-cloud-to-tf"
	ExecuteKICSScan(inputPaths, outputPath)
}

func ExecuteKICSScan(inputPaths []string, outputPath string) {
	params := scan.GetDefaultParameters()
	params.Path = inputPaths
	params.OutputPath = outputPath
	console.ExecuteScan(params)
}
