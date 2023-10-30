package Cx

import data.generic.dockerfile as dockerLib

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
		"keyExpectedValue": sprintf("{{%s}} should avoid manual input", [resource.Original]),
		"keyActualValue": sprintf("{{%s}} doesn't avoid manual input", [resource.Original]),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	count(resource.Value) > 1

    dockerLib.arrayContains(resource.Value, {"yum", "install"})

	not avoidManualInputInList(resource.Value)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}} should avoid manual input", [resource.Original]),
		"keyActualValue": sprintf("{{%s}} doesn't avoid manual input", [resource.Original]),
	}
}

isYumInstall(command) {
	regex.match("yum (-(-)?[a-zA-Z]+ *)*(group|local)?install", command)
}

avoidManualInput(command) {
	regex.match("yum (-(-)?[a-zA-Z]+ *)*(-y|-yes|--assumeyes) (-(-)?[a-zA-Z]+ *)*(group|local)?install", command)
}

avoidManualInput(command) {
	regex.match("yum (-(-)?[a-zA-Z]+ *)*(group|local)?install (-(-)?[a-zA-Z]+ *)*(-y|-yes|--assumeyes)", command)
}

avoidManualInput(command) {
	regex.match("yum (-(-)?[a-zA-Z]+ *)*(group|local)?install ([A-Za-z0-9-:=.$_]+ *)*(-y|-yes|--assumeyes)", command)
}

avoidManualInputInList(command) {
	flags := ["-y", "yes", "--assumeyes"]

	contains(command[j], flags[x])
}
