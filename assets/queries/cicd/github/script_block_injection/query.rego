package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	doc.on.pull_request_target

	uses := doc.jobs[j].steps[k].uses

	startswith(uses, "actions/github-script")

	script := doc.jobs[j].steps[k]["with"].script

	patterns := [
		"github.head_ref",
		"github.event.pull_request.body",
		"github.event.pull_request.head.label",
		"github.event.pull_request.head.ref",
		"github.event.pull_request.head.repo.default_branch",
		"github.event.pull_request.head.repo.description",
		"github.event.pull_request.head.repo.homepage",
		"github.event.pull_request.title",
	]

	matched = containsPatterns(script, patterns)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("script={{%s}}", [script]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Script block does not contain dangerous input controlled by user.",
		"keyActualValue": "Script block contains dangerous input controlled by user.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "with", "script"], []),
		"searchValue": matched[m],
	}
}

CxPolicy[result] {
	some doc in input.document
	doc.on.issues

	uses := doc.jobs[j].steps[k].uses

	startswith(uses, "actions/github-script")

	script := doc.jobs[j].steps[k]["with"].script

	patterns := [
		"github.event.issue.body",
		"github.event.issue.title",
	]

	matched = containsPatterns(script, patterns)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("script={{%s}}", [script]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Script block does not contain dangerous input controlled by user.",
		"keyActualValue": "Script block contains dangerous input controlled by user.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "with", "script"], []),
		"searchValue": matched[m],
	}
}

CxPolicy[result] {
	some doc in input.document
	doc.on.issue_comment

	uses := doc.jobs[j].steps[k].uses

	startswith(uses, "actions/github-script")

	script := doc.jobs[j].steps[k]["with"].script

	patterns := [
		"github.event.comment.body",
		"github.event.issue.body",
		"github.event.issue.title",
	]

	matched = containsPatterns(script, patterns)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("script={{%s}}", [script]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Script block does not contain dangerous input controlled by user.",
		"keyActualValue": "Script block contains dangerous input controlled by user.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "with", "script"], []),
		"searchValue": matched[m],
	}
}

CxPolicy[result] {
	some doc in input.document
	doc.on.discussion

	uses := doc.jobs[j].steps[k].uses

	startswith(uses, "actions/github-script")

	script := doc.jobs[j].steps[k]["with"].script

	patterns := [
		"github.event.discussion.body",
		"github.event.discussion.title",
	]

	matched = containsPatterns(script, patterns)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("script={{%s}}", [script]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Script block does not contain dangerous input controlled by user.",
		"keyActualValue": "Script block contains dangerous input controlled by user.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "with", "script"], []),
		"searchValue": matched[m],
	}
}

CxPolicy[result] {
	some doc in input.document
	doc.on.discussion_comment

	uses := doc.jobs[j].steps[k].uses

	startswith(uses, "actions/github-script")

	script := doc.jobs[j].steps[k]["with"].script

	patterns := [
		"github.event.comment.body",
		"github.event.discussion.body",
		"github.event.discussion.title",
	]

	matched = containsPatterns(script, patterns)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("script={{%s}}", [script]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Script block does not contain dangerous input controlled by user.",
		"keyActualValue": "Script block contains dangerous input controlled by user.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "with", "script"], []),
		"searchValue": matched[m],
	}
}

CxPolicy[result] {
	some doc in input.document
	doc.on.workflow_run

	uses := doc.jobs[j].steps[k].uses

	startswith(uses, "actions/github-script")

	script := doc.jobs[j].steps[k]["with"].script

	patterns := [
		"github.event.workflow.path",
		"github.event.workflow_run.head_branch",
		"github.event.workflow_run.head_commit.author.email",
		"github.event.workflow_run.head_commit.author.name",
		"github.event.workflow_run.head_commit.message",
		"github.event.workflow_run.head_repository.description",
	]

	matched = containsPatterns(script, patterns)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("script={{%s}}", [script]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Script block does not contain dangerous input controlled by user.",
		"keyActualValue": "Script block contains dangerous input controlled by user.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "with", "script"], []),
		"searchValue": matched[m],
	}
}

CxPolicy[result] {
	some doc in input.document
	doc.on.author

	uses := doc.jobs[j].steps[k].uses

	startswith(uses, "actions/github-script")

	script := doc.jobs[j].steps[k]["with"].script

	patterns := [
		"github.*.authors.name",
		"github.*.authors.email",
	]

	matched = containsPatterns(script, patterns)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("script={{%s}}", [script]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Script block does not contain dangerous input controlled by user.",
		"keyActualValue": "Script block contains dangerous input controlled by user.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "with", "script"], []),
		"searchValue": matched[m],
	}
}

containsPatterns(str, patterns) = {pattern |
	pattern := patterns[_]
	regex.match(pattern, str)
}
