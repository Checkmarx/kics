package Cx

import future.keywords.in

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name]
	dockerLib.check_multi_stage(name, input.document[i].command)

    not "healthcheck" in [cmd | cmd := resource[_].Cmd]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Dockerfile should contain instruction 'HEALTHCHECK'",
		"keyActualValue": "Dockerfile doesn't contain instruction 'HEALTHCHECK'",
	}
}
