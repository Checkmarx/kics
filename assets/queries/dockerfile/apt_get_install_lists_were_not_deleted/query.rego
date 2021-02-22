package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	commands := resource.Value[0]

	aptGet := regex.find_n("apt-get (-(-)?[a-zA-Z]+ *)*install", commands, -1)
	aptGet != null

	not hasClean(resource.Value[0], aptGet[0])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, commands]),
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": "After using apt-get install, it is needed to delete apt-get lists",
		"keyActualValue": "After using apt-get install, the apt-get lists were not deleted",
	}
}

hasClean(resourceValue, aptGet) {
	listCommands := split(resourceValue, "&& ")

	startswith(listCommands[install], aptGet)

	some clean
	startswith(listCommands[clean], "apt-get clean")

	some remove
	startswith(listCommands[remove], "rm -rf")

	install < clean
	clean < remove
}
