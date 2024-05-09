package testcases

import (
	"os"
	"path/filepath"

	u "github.com/Checkmarx/kics/v2/e2e/utils"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/remediation"
	"github.com/Checkmarx/kics/v2/pkg/report"
	"github.com/Checkmarx/kics/v2/pkg/utils"
	"github.com/rs/zerolog/log"
)

func generateReport(tmpFile, jsonPath, reportName string) { //nolint
	var queryHigh = model.QueryResult{
		QueryName:                   "Ram Account Password Policy Not Required Minimum Length",
		QueryID:                     "a9dfec39-a740-4105-bbd6-721ba163c053",
		QueryURI:                    "",
		Description:                 "Ram Account Password Policy should have 'minimum_password_length' defined and set to 14 or above",
		DescriptionID:               "a8b47743",
		CISDescriptionIDFormatted:   "testCISID",
		CISDescriptionTitle:         "testCISTitle",
		CISDescriptionTextFormatted: "testCISDescription",
		Severity:                    model.SeverityHigh,
		Platform:                    "Terraform",
		CloudProvider:               "ALICLOUD",
		Category:                    "Secret Management",
		Files: []model.VulnerableFile{
			{
				FileName:         tmpFile,
				SimilarityID:     "f282fa13cf5e4ffd4bbb0ee2059f8d0240edcd2ca54b3bb71633145d961de5ce",
				Line:             1,
				ResourceType:     "alicloud_ram_account_password_policy",
				ResourceName:     "corporate1",
				IssueType:        "MissingAttribute",
				SearchKey:        "alicloud_ram_account_password_policy[corporate1]",
				SearchLine:       0,
				SearchValue:      "",
				KeyExpectedValue: "'minimum_password_length' is defined and set to 14 or above ",
				KeyActualValue:   "'minimum_password_length' is not defined",
				Value:            nil,
				Remediation:      "minimum_password_length = 14",
				RemediationType:  "addition",
			},
		},
	}

	var queryMedium1 = model.QueryResult{ //nolint
		QueryName:                   "RAM Account Password Policy Not Required Symbols",
		QueryID:                     "41a38329-d81b-4be4-aef4-55b2615d3282",
		QueryURI:                    "",
		Description:                 "RAM account password security should require at least one symbol",
		DescriptionID:               "f3616c34",
		CISDescriptionIDFormatted:   "testCISID",
		CISDescriptionTitle:         "testCISTitle",
		CISDescriptionTextFormatted: "testCISDescription",
		Severity:                    model.SeverityMedium,
		Platform:                    "Terraform",
		CloudProvider:               "ALICLOUD",
		Category:                    "Secret Management",
		Files: []model.VulnerableFile{
			{
				FileName:         tmpFile,
				SimilarityID:     "87abbee5d0ec977ba193371c702dca2c040ea902d2e606806a63b66119ff89bc",
				Line:             5,
				ResourceType:     "alicloud_ram_account_password_policy",
				ResourceName:     "corporate1",
				IssueType:        "IncorrectValue",
				SearchKey:        "resource.alicloud_ram_account_password_policy[corporate1].require_symbols",
				SearchLine:       0,
				SearchValue:      "",
				KeyExpectedValue: "resource.alicloud_ram_account_password_policy[corporate1].require_symbols is set to 'true'",
				KeyActualValue:   "resource.alicloud_ram_account_password_policy[corporate1].require_symbols is configured as 'false'",
				Value:            nil,
				Remediation:      "{\"after\":\"true\",\"before\":\"false\"}",
				RemediationType:  "replacement",
			},
			{
				FileName:         tmpFile,
				SimilarityID:     "2628457bdb548986936dbd7d8479524f2079f26d36b9faa9f34423e796fe62c8",
				Line:             16,
				ResourceType:     "alicloud_ram_account_password_policy",
				ResourceName:     "corporate2",
				IssueType:        "IncorrectValue",
				SearchKey:        "resource.alicloud_ram_account_password_policy[corporate2].require_symbols",
				SearchLine:       0,
				SearchValue:      "",
				KeyExpectedValue: "resource.alicloud_ram_account_password_policy[corporate2].require_symbols is set to 'true'",
				KeyActualValue:   "resource.alicloud_ram_account_password_policy[corporate2].require_symbols is configured as 'false'",
				Value:            nil,
				Remediation:      "{\"after\":\"true\",\"before\":\"false\"}",
				RemediationType:  "replacement",
			},
		},
	}

	var queryMedium2 = model.QueryResult{ //nolint
		QueryName:                   "Ram Account Password Policy Max Password Age Unrecommended",
		QueryID:                     "2bb13841-7575-439e-8e0a-cccd9ede2fa8",
		Description:                 "Ram Account Password Policy Password 'max_password_age' should be higher than 0 and lower than 91",
		QueryURI:                    "",
		DescriptionID:               "6056f5ca",
		CISDescriptionIDFormatted:   "testCISID",
		CISDescriptionTitle:         "testCISTitle",
		CISDescriptionTextFormatted: "testCISDescription",
		Severity:                    model.SeverityMedium,
		Platform:                    "Terraform",
		CloudProvider:               "ALICLOUD",
		Category:                    "Secret Management",
		Files: []model.VulnerableFile{
			{
				FileName:         tmpFile,
				SimilarityID:     "f1d17b3513439e03cd0a25690acc44755d4e68decfaa6c03522b20a65b26b617",
				Line:             5,
				ResourceType:     "alicloud_ram_account_password_policy",
				ResourceName:     "corporate1",
				IssueType:        "MissingAttribute",
				SearchKey:        "alicloud_ram_account_password_policy[corporate1]",
				SearchLine:       0,
				SearchValue:      "",
				KeyExpectedValue: "'max_password_age' should be higher than 0 and lower than 91",
				KeyActualValue:   "'max_password_age' is not defined",
				Value:            nil,
				Remediation:      "max_password_age = 12",
				RemediationType:  "addition",
			},
			{
				FileName:         tmpFile,
				SimilarityID:     "404ad93f4a485d0dd1b1621489c38be9c98dcc0b94396701ecad162e28db97fd",
				Line:             11,
				ResourceType:     "alicloud_ram_account_password_policy",
				ResourceName:     "corporate2",
				IssueType:        "MissingAttribute",
				SearchKey:        "alicloud_ram_account_password_policy[corporate2]",
				SearchLine:       0,
				SearchValue:      "",
				KeyExpectedValue: "'max_password_age' should be higher than 0 and lower than 91",
				KeyActualValue:   "'max_password_age' is not defined",
				Value:            nil,
				Remediation:      "max_password_age = 12",
				RemediationType:  "addition",
			},
		},
	}

	var summary = model.Summary{
		Counters: model.Counters{
			ScannedFiles:           1,
			ParsedFiles:            1,
			FailedToScanFiles:      0,
			TotalQueries:           3,
			FailedToExecuteQueries: 0,
		},
		Queries: []model.QueryResult{
			queryHigh,
			queryMedium1,
			queryMedium2,
		},
		SeveritySummary: model.SeveritySummary{
			ScanID: "console",
			SeverityCounters: map[model.Severity]int{
				model.SeverityInfo:     0,
				model.SeverityLow:      0,
				model.SeverityMedium:   4,
				model.SeverityHigh:     1,
				model.SeverityCritical: 0,
			},
			TotalCounter: 5,
		},
		ScannedPaths: []string{
			tmpFile,
		},
	}

	// create JSON report
	err := report.PrintJSONReport(jsonPath, reportName, summary)

	if err != nil {
		log.Error().Msgf("failed to create JSON report: %s", err)
	}
}

func generateResults(reportName string) {
	cwd, err := os.Getwd()

	if err != nil {
		log.Error().Msgf("failed to get wd: %s", err)
	}

	tmpFolderPath := filepath.Join(cwd, "tmp-kics-ar")

	perm := 0777 // only for E2E tests

	if err = os.MkdirAll(tmpFolderPath, os.FileMode(perm)); err != nil {
		log.Error().Msgf("failed to mkdir: %s", err)
	}

	filePathCopyFrom := filepath.Join(cwd, "fixtures", "samples", "kics-auto-remediation", "terraform.tf")

	tmpFileName := utils.NextRandom() + filepath.Ext(filePathCopyFrom)
	tmpFilePath := filepath.Join(cwd, "tmp-kics-ar", tmpFileName)

	jsonPath := tmpFolderPath

	// create a temporary file with the same content as filePathCopyFrom
	tmpFile := remediation.CreateTempFile(filePathCopyFrom, tmpFilePath)

	err = os.Chmod(tmpFile, os.FileMode(perm))

	if err != nil {
		log.Error().Msgf("failed to chmod file %s: %s", tmpFile, err)
	}

	kicsDockerImage := u.GetKICSDockerImageName()
	useDocker := kicsDockerImage != ""

	if useDocker {
		tmpFile = "/path/e2e/tmp-kics-ar/" + tmpFileName
	}

	// create JSON results with remediation
	generateReport(tmpFile, jsonPath, reportName)
}
