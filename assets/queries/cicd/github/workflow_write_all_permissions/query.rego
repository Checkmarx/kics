package Cx

import data.generic.common as common_lib

# Detect 'permissions: write-all' at the workflow level or job level.
#
# 'write-all' grants the GITHUB_TOKEN maximum write access across ALL scopes:
# contents, pull-requests, issues, checks, statuses, packages, deployments,
# discussions, id-token, and more. This is the broadest possible permission
# grant and violates the principle of least privilege.
#
# If any step executes untrusted code (e.g. from a fork, an issue comment,
# or a compromised action), the attacker inherits all write permissions.
#
# Fix: replace 'write-all' with an explicit list of only the permissions
# the workflow actually needs:
#
#   permissions:
#     contents: read
#     pull-requests: write

# Workflow-level write-all: all jobs inherit maximum permissions
CxPolicy[result] {
	input.document[i].permissions == "write-all"

	result := {
		"documentId": input.document[i].id,
		"searchKey": "permissions={{write-all}}",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "permissions declares only the specific scopes the workflow requires.",
		"keyActualValue": "permissions is set to write-all at the workflow level, granting maximum GITHUB_TOKEN permissions to all jobs.",
		"searchLine": common_lib.build_search_line(["permissions"], []),
	}
}

# Job-level write-all: the specific job gets maximum permissions
CxPolicy[result] {
	input.document[i].jobs[j].permissions == "write-all"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("jobs.%s.permissions={{write-all}}", [j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("jobs.%s.permissions declares only the specific scopes the job requires.", [j]),
		"keyActualValue": sprintf("jobs.%s.permissions is set to write-all, granting maximum GITHUB_TOKEN permissions to the job.", [j]),
		"searchLine": common_lib.build_search_line(["jobs", j, "permissions"], []),
	}
}
