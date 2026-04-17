package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	command := input.document[i].command[name][_]
	command.Cmd == "expose"

	to_number(command.Value[_]) == 22

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, command.Original]), from_command.LineHint),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'EXPOSE' shouldn't contain the port 22 ",
		"keyActualValue": "'EXPOSE' contains the port 22 ",
	}
}
