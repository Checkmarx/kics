package Cx

import data.generic.common as common_lib

# GHSA-mrrh-fwg8-r2c3 / CVE-2025-30066: all tj-actions/changed-files
# versions <= 45.0.7 are vulnerable (fixed in 46.0.1). During the March
# 2025 supply-chain attack, every affected version tag (v1 through
# v45.0.7) was retroactively rewritten to point at the malicious commit
# below, so pinning to any vulnerable version tag - not just v45 - is a
# risk, and pinning directly to the known-malicious commit is a
# confirmed compromise indicator.
compromised_commit := "0e58ed8671d6b60d0890c21b07f8835ace038e67"

CxPolicy[result] {
	uses := input.document[i].jobs[j].steps[k].uses
	startswith(uses, "tj-actions/changed-files@")
	ref := substring(uses, count("tj-actions/changed-files@"), -1)
	isVulnerableRef(ref)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("uses={{%s}}", [uses]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "tj-actions/changed-files should be pinned to v46.0.1 or later (or its full-length commit SHA)",
		"keyActualValue": sprintf("'%s' is pinned to a version vulnerable to secret discovery (GHSA-mrrh-fwg8-r2c3, CVE-2025-30066)", [uses]),
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "uses"], []),
	}
}

isVulnerableRef(ref) {
	ref == compromised_commit
}

isVulnerableRef(ref) {
	matches := regex.find_all_string_submatch_n(`^v(\d+)(?:\.(\d+)(?:\.(\d+))?)?$`, ref, 1)
	count(matches) == 1
	major := to_number(matches[0][1])
	minor := numberOrZero(matches[0][2])
	patch := numberOrZero(matches[0][3])
	versionLessOrEqual(major, minor, patch, 45, 0, 7)
}

numberOrZero(s) = 0 {
	s == ""
} else = n {
	n := to_number(s)
}

versionLessOrEqual(maj1, _, _, maj2, _, _) {
	maj1 < maj2
}

versionLessOrEqual(maj1, min1, _, maj2, min2, _) {
	maj1 == maj2
	min1 < min2
}

versionLessOrEqual(maj1, min1, pat1, maj2, min2, pat2) {
	maj1 == maj2
	min1 == min2
	pat1 <= pat2
}
