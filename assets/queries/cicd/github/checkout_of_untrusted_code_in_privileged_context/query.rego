package Cx

import data.generic.common as common_lib

# Detect checkout of attacker-controlled code in a pull_request_target workflow.
#
# pull_request_target runs with the target repo's secrets and write permissions.
# Checking out the PR contributor's branch/commit (head ref) and then executing
# any code from that checkout gives the attacker elevated access ("pwn request").
#
# Safe pattern: check out only the base branch ref (pull_request.base.sha / base.ref).
# Unsafe patterns include: pull_request.head.sha, pull_request.head.ref, head_ref, etc.

CxPolicy[result] {
	input.document[i].on["pull_request_target"]

	step := input.document[i].jobs[j].steps[k]
	startswith(step.uses, "actions/checkout")

	ref := step["with"].ref
	isUntrustedHeadRef(ref)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("jobs.%s.steps.with.ref={{%s}}", [j, ref]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Checkout uses a trusted base branch ref (e.g. github.event.pull_request.base.sha) in a pull_request_target workflow.",
		"keyActualValue": "Checkout uses an untrusted PR head ref in a pull_request_target workflow, allowing execution of attacker-controlled code with elevated permissions.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "with", "ref"], []),
	}
}

# Matches any ref expression that references the PR head (attacker-controlled):
#   github.event.pull_request.head.*  (e.g. .sha, .ref, .label, .repo.*)
#   github.head_ref

isUntrustedHeadRef(ref) {
	regex.match("github\\.event\\.pull_request\\.head", ref)
}

isUntrustedHeadRef(ref) {
	regex.match("github\\.head_ref", ref)
}
