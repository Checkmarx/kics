package Cx

CxPolicy[result] {
	command := input.document[i].command[name][_]
	command.Cmd == "expose"

	containsPortOutOfRange(command.Value)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, command.Original]),
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
