package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	command := input.document[i].command[name][_]
	command.Cmd == "expose"

	containsPortOutOfRange(command.Value)

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}.{{%s}}", [from_command, name, command.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'EXPOSE' should not contain ports out of range [0, 65535]",
		"keyActualValue": "'EXPOSE' contains ports out of range [0, 65535]",
	}
}

containsPortOutOfRange(ports) {
	some p
	port := to_number(split(ports[p], "/")[0])
	port > 65535
}
