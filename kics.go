package kics

import (
	"github.com/Checkmarx/kics/internal/console"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/scan"
)

func ExecuteKICSScan(inputPaths []string, outputPath string, sciInfo model.SCIInfo) {
	params := scan.GetDefaultParameters()
	params.Path = inputPaths
	params.OutputPath = outputPath
	params.SCIInfo = sciInfo
	console.ExecuteScan(params)
}
