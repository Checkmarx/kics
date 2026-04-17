package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	stage := input.document[i].command[name]

	resource = stage[s]
	stage[s].Cmd = "add"
	not dockerLib.arrayContains(stage[s].Value, {".tar", ".tar."})

	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, resource.Original]), from_command.LineHint),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'COPY' %s", [resource.Value[0]]),
		"keyActualValue": sprintf("'ADD' %s", [resource.Value[0]]),
	}
}