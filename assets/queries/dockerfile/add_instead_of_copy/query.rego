package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "add"

	not dockerLib.arrayContains(resource.Value, {".tar", ".tar."})

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}.{{%s}}", [from_command, name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'COPY' %s", [resource.Value[0]]),
		"keyActualValue": sprintf("'ADD' %s", [resource.Value[0]]),
	}
}
