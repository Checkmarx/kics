package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	env := doc.env.ACTIONS_ALLOW_UNSECURE_COMMANDS
	env == true

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("env.actions_allow_unsecure_commands={{%s}}", [env]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ACTIONS_ALLOW_UNSECURE_COMMANDS environment variable is not set as true.",
		"keyActualValue": "ACTIONS_ALLOW_UNSECURE_COMMANDS environment variable is set as true.",
		"searchLine": common_lib.build_search_line(["env", "ACTIONS_ALLOW_UNSECURE_COMMANDS"], []),
	}
}

CxPolicy[result] {
	some doc in input.document
	env := doc.jobs[j].env.ACTIONS_ALLOW_UNSECURE_COMMANDS
	env == true

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("env.actions_allow_unsecure_commands={{%s}}", [env]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ACTIONS_ALLOW_UNSECURE_COMMANDS environment variable is not set as true.",
		"keyActualValue": "ACTIONS_ALLOW_UNSECURE_COMMANDS environment variable is set as true.",
		"searchLine": common_lib.build_search_line(["jobs", j, "env", "ACTIONS_ALLOW_UNSECURE_COMMANDS"], []),
	}
}

CxPolicy[result] {
	some doc in input.document
	env := doc.jobs[j].steps[k].env.ACTIONS_ALLOW_UNSECURE_COMMANDS
	env == true

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("env.actions_allow_unsecure_commands={{%s}}", [env]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ACTIONS_ALLOW_UNSECURE_COMMANDS environment variable is not set as true.",
		"keyActualValue": "ACTIONS_ALLOW_UNSECURE_COMMANDS environment variable is set as true.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "env", "ACTIONS_ALLOW_UNSECURE_COMMANDS"], []),
	}
}
