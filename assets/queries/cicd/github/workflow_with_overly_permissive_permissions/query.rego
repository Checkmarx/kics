package Cx

import data.generic.common as common_lib

# Detect write permissions granted at the workflow level in a pull_request_target workflow.
#
# pull_request_target runs with the target repo's elevated permissions. Setting
# pull-requests: write or contents: write at the workflow (top) level means ALL
# jobs inherit those rights, including jobs that check out and execute untrusted
# fork code. Write access should be scoped to only the specific jobs that need it
# (e.g. a separate reporting or merge job), using job-level permissions blocks.
#
# Safe pattern  : workflow-level permissions set to read; individual jobs that
#                 genuinely need write have their own permissions block.
# Unsafe pattern: workflow-level pull-requests: write or contents: write.

CxPolicy[result] {
	input.document[i].on["pull_request_target"]

	perm := input.document[i].permissions

	# Check each permission that should default to read in this context
	sensitivePerms := ["pull-requests", "contents"]
	permName := sensitivePerms[_]
	perm[permName] == "write"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("permissions.%s={{write}}", [permName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("permissions.%s is set to read at the workflow level; grant write only in the specific job(s) that require it.", [permName]),
		"keyActualValue": sprintf("permissions.%s is set to write at the workflow level in a pull_request_target workflow, granting all jobs elevated write access.", [permName]),
		"searchLine": common_lib.build_search_line(["permissions", permName], []),
	}
}
