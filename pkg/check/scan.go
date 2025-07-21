package check

import (
	"github.com/Checkmarx/kics/v2/internal/console"
	"github.com/Checkmarx/kics/v2/pkg/scan"
)

func ExecuteScan(params *scan.Parameters) error {
	return console.ExecuteScan(params)
}
