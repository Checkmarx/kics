package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	count(resource.Value) == 1

	command := resource.Value[0]
	isYumInstall(command)

	not avoidManualInput(command)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("FROM={{%s}}.{{%s}} avoids manual input", [name, resource.Original]),
		"keyActualValue": sprintf("FROM={{%s}}.{{%s}} doesn't avoid manual input", [name, resource.Original]),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	count(resource.Value) > 1

	isYumInstallInList(resource.Value)

	not avoidManualInputInList(resource.Value)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("FROM={{%s}}.{{%s}} avoids manual input", [name, resource.Original]),
		"keyActualValue": sprintf("FROM={{%s}}.{{%s}} doesn't avoid manual input", [name, resource.Original]),
	}
}

isYumInstall(command) {
	regex.match("yum (-(-)?[a-zA-Z]+ *)*(group|local)?install", command)
}

avoidManualInput(command) {
	regex.match("yum (-(-)?[a-zA-Z]+ *)*(-y|-yes|--assumeyes) (-(-)?[a-zA-Z]+ *)*(group|local)?install", command)
}

avoidManualInput(command) {
	regex.match("yum (-(-)?[a-zA-Z]+ *)*(group|local)?install (-(-)?[a-zA-Z]+ *)*(-y|-yes|--assumeyes) (-(-)?[a-zA-Z]+ *)*", command)
}

isYumInstallInList(command) {
	contains(command[x], "yum")
	contains(command[j], "install")
}

avoidManualInputInList(command) {
	flags := ["-y", "yes", "--assumeyes"]

	contains(command[j], flags[x])
}
