package Cx

CxPolicy[result] {
	command := input.document[i].command[name][_]
	command.Cmd == "expose"

	to_number(command.Value[_]) == 22

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, command.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'EXPOSE' shouldn't contain the port 22 ",
		"keyActualValue": "'EXPOSE' contains the port 22 ",
	}
}
