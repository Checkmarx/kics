package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) == 1

	command := resource.Value[j]
	isAptGet(command)

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

	isAptGetInList(resource.Value)

	not avoidManualInputInList(resource.Value)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("FROM={{%s}}.{{%s}} avoids manual input", [name, resource.Original]),
		"keyActualValue": sprintf("FROM={{%s}}.{{%s}} doesn't avoid manual input", [name, resource.Original]),
	}
}

isAptGet(command) {
	regex.match("apt-get (-(-)?[a-zA-Z]+ *)*install", command)
}

isAptGetInList(command) {
	contains(command[x], "apt-get")
	contains(command[j], "install")
}

avoidManualInputInList(command) {
	flags := ["-y", "yes", "--assumeyes"]

	contains(command[j], flags[x])
}

isAptGet(command) {
	regex.match("apt-get (-(-)?[a-zA-Z]+ *)*install", command)
}

avoidManualInput(command) {
	regex.match("apt-get (-(-)?[a-zA-Z]+ *)*(-y|-yes|--assumeyes) (-(-)?[a-zA-Z]+ *)*install", command)
}

avoidManualInput(command) {
	regex.match("apt-get (-(-)?[a-zA-Z]+ *)*install (-(-)?[a-zA-Z]+ *)*(-y|-yes|--assumeyes)", command)
}

avoidManualInput(command) {
	regex.match("apt-get (-(-)?[a-zA-Z]+ *)*install ([A-Za-z0-9-:=.$_]+ *)*(-y|-yes|--assumeyes)", command)
}
