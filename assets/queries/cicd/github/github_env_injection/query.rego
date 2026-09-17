package Cx

import data.generic.common as common_lib

# Detect untrusted user-controlled context variables written to $GITHUB_ENV
# or $GITHUB_PATH in run blocks.
#
# Writing attacker-controlled data to $GITHUB_ENV sets environment variables
# for all subsequent steps. Writing to $GITHUB_PATH adds entries to the PATH
# used by subsequent steps. Either can be exploited to hijack step execution.
#
# This is a different risk from direct run-block injection: the offending step
# may look benign (a simple `echo`), but the environment it contaminates is
# consumed by downstream steps that may be trusted actions or scripts.

# pull_request_target: PR head ref, branch, title and body are attacker-controlled
CxPolicy[result] {
	input.document[i].on["pull_request_target"]
	run := input.document[i].jobs[j].steps[k].run

	writesToGithubEnvOrPath(run)

	patterns := [
		"github\\.head_ref",
		"github\\.event\\.pull_request\\.head",
		"github\\.event\\.pull_request\\.title",
		"github\\.event\\.pull_request\\.body",
	]

	matched = containsPatterns(run, patterns)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("run={{%s}}", [run]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Run block does not write attacker-controlled context variables to GITHUB_ENV or GITHUB_PATH.",
		"keyActualValue": "Run block writes attacker-controlled data to GITHUB_ENV or GITHUB_PATH, allowing environment manipulation for subsequent steps.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "run"], []),
		"searchValue": matched[_],
	}
}

# issue_comment: comment body is fully attacker-controlled
CxPolicy[result] {
	input.document[i].on["issue_comment"]
	run := input.document[i].jobs[j].steps[k].run

	writesToGithubEnvOrPath(run)

	patterns := [
		"github\\.event\\.comment\\.body",
		"github\\.event\\.issue\\.title",
		"github\\.event\\.issue\\.body",
	]

	matched = containsPatterns(run, patterns)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("run={{%s}}", [run]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Run block does not write attacker-controlled context variables to GITHUB_ENV or GITHUB_PATH.",
		"keyActualValue": "Run block writes attacker-controlled data to GITHUB_ENV or GITHUB_PATH, allowing environment manipulation for subsequent steps.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "run"], []),
		"searchValue": matched[_],
	}
}

# issues: issue title and body are attacker-controlled
CxPolicy[result] {
	input.document[i].on["issues"]
	run := input.document[i].jobs[j].steps[k].run

	writesToGithubEnvOrPath(run)

	patterns := [
		"github\\.event\\.issue\\.title",
		"github\\.event\\.issue\\.body",
	]

	matched = containsPatterns(run, patterns)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("run={{%s}}", [run]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Run block does not write attacker-controlled context variables to GITHUB_ENV or GITHUB_PATH.",
		"keyActualValue": "Run block writes attacker-controlled data to GITHUB_ENV or GITHUB_PATH, allowing environment manipulation for subsequent steps.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "run"], []),
		"searchValue": matched[_],
	}
}

# workflow_run: head branch and commit metadata are attacker-controlled
CxPolicy[result] {
	input.document[i].on["workflow_run"]
	run := input.document[i].jobs[j].steps[k].run

	writesToGithubEnvOrPath(run)

	patterns := [
		"github\\.event\\.workflow_run\\.head_branch",
		"github\\.event\\.workflow_run\\.head_commit\\.message",
		"github\\.event\\.workflow_run\\.head_commit\\.author",
		"github\\.event\\.workflow_run\\.head_repository\\.description",
	]

	matched = containsPatterns(run, patterns)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("run={{%s}}", [run]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Run block does not write attacker-controlled context variables to GITHUB_ENV or GITHUB_PATH.",
		"keyActualValue": "Run block writes attacker-controlled data to GITHUB_ENV or GITHUB_PATH, allowing environment manipulation for subsequent steps.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "run"], []),
		"searchValue": matched[_],
	}
}

# The run block appends to $GITHUB_ENV or $GITHUB_PATH
writesToGithubEnvOrPath(run) {
	regex.match(`>>\s*"?\$GITHUB_ENV"?`, run)
}

writesToGithubEnvOrPath(run) {
	regex.match(`>>\s*"?\$GITHUB_PATH"?`, run)
}

containsPatterns(str, patterns) = matched {
	matched := {pattern |
		pattern := patterns[_]
		regex.match(pattern, str)
	}
}
