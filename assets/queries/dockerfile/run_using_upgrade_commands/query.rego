package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	commands := {"apt-get upgrade", "apt-get dist-upgrade"}

	contains(resource.Value[x], commands[j])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("RUN instructions does not have '%s' command", [commands[j]]),
		"keyActualValue": sprintf("RUN instructions have '%s' command", [commands[j]]),
	}
}
