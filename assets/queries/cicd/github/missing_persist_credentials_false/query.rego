package Cx

import data.generic.common as common_lib

# Detect actions/checkout steps in pull_request_target workflows that do not
# set persist-credentials: false.
#
# pull_request_target runs with the target repository's elevated permissions.
# actions/checkout defaults to persist-credentials: true, which writes the
# GITHUB_TOKEN into .git/config so subsequent git operations are authenticated.
#
# If the workflow (or a later step) runs any code that reads .git/config —
# including code from a fork PR — that code can extract the token and use it
# to make authenticated GitHub API calls, exfiltrate secrets, or push changes.
#
# Setting persist-credentials: false ensures credentials are never written to
# disk, limiting the blast radius of any compromised step.

CxPolicy[result] {
	input.document[i].on["pull_request_target"]

	step := input.document[i].jobs[j].steps[k]
	startswith(step.uses, "actions/checkout")

	# persist-credentials is not explicitly set to false
	not step["with"]["persist-credentials"] == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("jobs.%s.steps.uses={{%s}}", [j, step.uses]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("jobs.%s.steps.with.persist-credentials is set to false.", [j]),
		"keyActualValue": sprintf("jobs.%s actions/checkout step does not set persist-credentials: false, leaving GitHub credentials written to .git/config in a privileged pull_request_target workflow.", [j]),
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "uses"], []),
	}
}
