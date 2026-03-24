package Cx

import data.generic.common as common_lib

# Detect self-hosted runners used in workflows that can be triggered by
# fork pull requests (pull_request or pull_request_target events).
#
# Self-hosted runners are persistent machines. If fork code reaches a
# self-hosted runner it can:
#   - Exfiltrate stored credentials, SSH keys, or environment variables
#   - Pivot to internal networks the runner has access to
#   - Install persistent backdoors on the runner
#   - Read files from previous workflow runs
#
# Use GitHub-hosted (ephemeral, isolated) runners for any job that may
# process untrusted fork contributions.
#
# runs-on can be a string: "self-hosted"
# or an array:             ["self-hosted", "linux", "x64"]

CxPolicy[result] {
	isForkPRTrigger(input.document[i].on)
	job := input.document[i].jobs[j]
	isSelfHosted(job["runs-on"])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("jobs.%s.runs-on={{%s}}", [j, job["runs-on"]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("jobs.%s.runs-on uses a GitHub-hosted ephemeral runner (e.g. ubuntu-latest) for fork-triggerable events.", [j]),
		"keyActualValue": sprintf("jobs.%s.runs-on uses a self-hosted runner in a workflow that can be triggered by untrusted fork pull requests.", [j]),
		"searchLine": common_lib.build_search_line(["jobs", j, "runs-on"], []),
	}
}

isForkPRTrigger(on) { on["pull_request"] }
isForkPRTrigger(on) { on["pull_request_target"] }

# String form: runs-on: self-hosted
isSelfHosted(runOn) { runOn == "self-hosted" }

# Array form: runs-on: [self-hosted, linux, x64]
isSelfHosted(runOn) { runOn[_] == "self-hosted" }
