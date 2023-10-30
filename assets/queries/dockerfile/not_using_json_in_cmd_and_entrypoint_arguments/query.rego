package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	dockerLib.check_multi_stage(name, input.document[i].command)

	resource.Cmd == "cmd"
	resource.JSON == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}} should be in the JSON Notation", [resource.Original]),
		"keyActualValue": sprintf("{{%s}} isn't in JSON Notation", [resource.Original]),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	dockerLib.check_multi_stage(name, input.document[i].command)

	resource.Cmd == "entrypoint"
	resource.JSON == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}} should be in the JSON Notation", [resource.Original]),
        "keyActualValue": sprintf("{{%s}} isn't in JSON Notation", [resource.Original]),
	}
}
