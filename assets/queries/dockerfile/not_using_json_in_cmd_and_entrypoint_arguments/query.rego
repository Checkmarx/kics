package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	dockerLib.check_multi_stage(name, input.document[i].command)

	resource.Cmd == "cmd"
	resource.JSON == false

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, resource.Original]), from_command.LineHint),
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

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, resource.Original]), from_command.LineHint),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}} should be in the JSON Notation", [resource.Original]),
        "keyActualValue": sprintf("{{%s}} isn't in JSON Notation", [resource.Original]),
	}
}
