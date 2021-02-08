package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]

	command := resource.Value[j]
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

isYumInstall(command) {
	regex.match("yum (-(-)?[a-zA-Z]+ *)*(group|local)?install", command)
}

avoidManualInput(command) {
	regex.match("yum (-(-)?[a-zA-Z]+ *)*(-y|-yes|--assumeyes) (-(-)?[a-zA-Z]+ *)*(group|local)?install", command)
}

avoidManualInput(command) {
	regex.match("yum (-(-)?[a-zA-Z]+ *)*(group|local)?install (-(-)?[a-zA-Z]+ *)*(-y|--assumeyes) (-(-)?[a-zA-Z]+ *)*", command)
}
