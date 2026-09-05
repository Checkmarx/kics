package Cx

import data.generic.common as common_lib

# Detect issue_comment triggered jobs that use slash commands without
# verifying the commenter's authorization.
#
# The issue_comment event fires for ANY comment from ANY GitHub user on
# issues and pull requests. A job whose `if` condition only checks the
# comment body for a slash command (e.g. /deploy, /version) with no
# identity check lets any user trigger that job — including jobs that
# check out and execute code from a forked PR.
#
# Fix: add an author_association guard to the job-level `if` condition:
#
#   github.event.comment.author_association == 'MEMBER' ||
#   github.event.comment.author_association == 'OWNER'   ||
#   github.event.comment.author_association == 'COLLABORATOR'
#
# This restricts command execution to trusted contributors only.

CxPolicy[result] {
	input.document[i].on["issue_comment"]

	job := input.document[i].jobs[j]
	jobIf := job["if"]

	# Job is conditioned on a slash command present in the comment body
	regex.match("contains\\(github\\.event\\.comment\\.body", jobIf)

	# But there is no check on who sent the comment
	not hasAuthorizationCheck(jobIf)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("jobs.%s.if={{%s}}", [j, jobIf]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("jobs.%s.if includes an authorization check such as github.event.comment.author_association == 'MEMBER'.", [j]),
		"keyActualValue": sprintf("jobs.%s.if triggers on a comment body command without verifying the commenter's authorization, allowing any user to trigger workflow execution.", [j]),
		"searchLine": common_lib.build_search_line(["jobs", j, "if"], []),
	}
}

# Authorization is considered present if the job if-condition checks
# the commenter's association or actor identity.
hasAuthorizationCheck(condition) {
	regex.match("author_association", condition)
}

hasAuthorizationCheck(condition) {
	regex.match("github\\.actor", condition)
}
