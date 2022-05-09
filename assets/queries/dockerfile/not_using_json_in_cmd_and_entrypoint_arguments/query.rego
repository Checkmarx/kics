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
		"keyExpectedValue": sprintf("FROM={{%s}}.{{%s}} is in the JSON Notation", [name, resource.Original]),
		"keyActualValue": sprintf("FROM={{%s}}.{{%s}} isn't in the JSON Notation", [name, resource.Original]),
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
		"keyExpectedValue": sprintf("FROM={{%s}}.{{%s}} is in the JSON Notation", [name, resource.Original]),
		"keyActualValue": sprintf("FROM={{%s}}.{{%s}} isn't in the JSON Notation", [name, resource.Original]),
	}
}
