package Cx

import data.generic.dockerfile as dockerLib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.command[name][_]
	dockerLib.check_multi_stage(name, document.command)

	resource.Cmd == "cmd"
	resource.JSON == false

	result := {
		"documentId": document.id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}} should be in the JSON Notation", [resource.Original]),
		"keyActualValue": sprintf("{{%s}} isn't in JSON Notation", [resource.Original]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.command[name][_]
	dockerLib.check_multi_stage(name, document.command)

	resource.Cmd == "entrypoint"
	resource.JSON == false

	result := {
		"documentId": document.id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}} should be in the JSON Notation", [resource.Original]),
		"keyActualValue": sprintf("{{%s}} isn't in JSON Notation", [resource.Original]),
	}
}
