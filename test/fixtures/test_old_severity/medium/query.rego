package Cx

import data.generic.common as common_lib

CxPolicy[result] {

	input.document[i].on["pull_request_target"]
	run := input.document[i].jobs[j].steps[k].run

	patterns := [
    "github.head_ref",
    "github.event.pull_request.body",
    "github.event.pull_request.head.label",
    "github.event.pull_request.head.ref",
    "github.event.pull_request.head.repo.default_branch",
    "github.event.pull_request.head.repo.description",
    "github.event.pull_request.head.repo.homepage",
    "github.event.pull_request.title"
	]

	matched = containsPatterns(run, patterns)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("run={{%s}}", [run]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Run block does not contain dangerous input controlled by user.",
		"keyActualValue": "Run block contains dangerous input controlled by user.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "run"],[]),
		"searchValue": matched[m]
	}
}

CxPolicy[result] {

	input.document[i].on["issues"]
	run := input.document[i].jobs[j].steps[k].run

	patterns := [
    "github.event.issue.body",
	"github.event.issue.title"
	]

	matched = containsPatterns(run, patterns)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("run={{%s}}", [run]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Run block does not contain dangerous input controlled by user.",
		"keyActualValue": "Run block contains dangerous input controlled by user.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "run"],[]),
		"searchValue": matched[m]
	}
}

CxPolicy[result] {

	input.document[i].on["issue_comment"]
	run := input.document[i].jobs[j].steps[k].run

	patterns := [
    "github.event.comment.body",
	"github.event.issue.body",
	"github.event.issue.title"
	]

	matched = containsPatterns(run, patterns)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("run={{%s}}", [run]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Run block does not contain dangerous input controlled by user.",
		"keyActualValue": "Run block contains dangerous input controlled by user.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "run"],[]),
		"searchValue": matched[m]
	}
}

CxPolicy[result] {

	input.document[i].on["discussion"]
	run := input.document[i].jobs[j].steps[k].run

	patterns := [
    "github.event.discussion.body",
	"github.event.discussion.title"
	]

	matched = containsPatterns(run, patterns)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("run={{%s}}", [run]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Run block does not contain dangerous input controlled by user.",
		"keyActualValue": "Run block contains dangerous input controlled by user.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "run"],[]),
		"searchValue": matched[m]
	}
}

CxPolicy[result] {

	input.document[i].on["discussion_comment"]
	run := input.document[i].jobs[j].steps[k].run

	patterns := [
    "github.event.comment.body",
	"github.event.discussion.body",
	"github.event.discussion.title"
	]

	matched = containsPatterns(run, patterns)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("run={{%s}}", [run]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Run block does not contain dangerous input controlled by user.",
		"keyActualValue": "Run block contains dangerous input controlled by user.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "run"],[]),
		"searchValue": matched[m]
	}
}

CxPolicy[result] {

	input.document[i].on["workflow_run"]
	run := input.document[i].jobs[j].steps[k].run

	patterns := [
    "github.event.workflow.path",
	"github.event.workflow_run.head_branch",
	"github.event.workflow_run.head_commit.author.email",
	"github.event.workflow_run.head_commit.author.name",
	"github.event.workflow_run.head_commit.message",
	"github.event.workflow_run.head_repository.description"
	]

	matched = containsPatterns(run, patterns)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("run={{%s}}", [run]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Run block does not contain dangerous input controlled by user.",
		"keyActualValue": "Run block contains dangerous input controlled by user.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "run"],[]),
		"searchValue": matched[m]
	}
}

CxPolicy[result] {

	input.document[i].on["author"]
	run := input.document[i].jobs[j].steps[k].run

	patterns := [
    "github.*.authors.name",
	"github.*.authors.email"
	]

	matched = containsPatterns(run, patterns)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("run={{%s}}", [run]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Run block does not contain dangerous input controlled by user.",
		"keyActualValue": "Run block contains dangerous input controlled by user.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "run"],[]),
		"searchValue": matched[m]
	}
}



containsPatterns(str, patterns) = matched {
    matched := {pattern |
        pattern := patterns[_]
        regex.match(pattern, str)
    }
}

