package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	count(resource.Value) == 1

	hasSudo(resource.Value[0])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instruction shouldn't contain sudo",
		"keyActualValue": "RUN instruction contains sudo",
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	count(resource.Value) > 1

	resource.Value[0] == "sudo"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instruction shouldn't contain sudo",
		"keyActualValue": "RUN instruction contains sudo",
	}
}

hasSudo(commands) {
	commandsList = dockerLib.getCommands(commands)

	some i
	instruction := commandsList[i]
	regex.match("^( )*sudo", instruction) == true
}
