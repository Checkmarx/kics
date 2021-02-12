package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) == 1
	commands := resource.Value[0]

	aptGet := regex.find_n("apt-get (-(-)?[a-zA-Z]+ *)*install", commands, -1)
	aptGet != null

	packages = dockerLib.getPackages(commands, aptGet)
	regex.match("^[a-zA-Z]", packages[j]) == true

	not dockerLib.withVersion(packages[j])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, commands]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Package '%s' has version defined", [packages[j]]),
		"keyActualValue": sprintf("Package '%s' does not have version defined", [packages[j]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) > 1

	isAptGet(resource.Value)

	resource.Value[j] != "install"
	resource.Value[j] != "apt-get"
	regex.match("^[a-zA-Z]", resource.Value[j]) == true
	not dockerLib.withVersion(resource.Value[j])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Package '%s' has version defined", [resource.Value[j]]),
		"keyActualValue": sprintf("Package '%s' does not have version defined", [resource.Value[j]]),
	}
}

isAptGet(command) {
	contains(command[x], "apt-get")
	contains(command[j], "install")
}
