package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	uses := input.document[i].jobs[j].steps[k].uses
	isVulnerableVersion(uses)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("uses={{%s}}", [uses]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "tj-actions/changed-files should be v46.0.1 or later",
		"keyActualValue": sprintf("'%s' uses a version vulnerable to secret discovery (GHSA-mrrh-fwg8-r2c3)", [uses]),
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "uses"], []),
	}
}

isVulnerableVersion(use) {
	allowed := ["tj-actions/changed-files@v45"]
	startswith(use, allowed[i])
}
