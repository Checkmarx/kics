package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) == 1
	commands := resource.Value[0]

	yum := regex.find_n("pip(3)? (-(-)?[a-zA-Z]+ *)*install", commands, -1)
	yum != null

	packages = dockerLib.getPackages(commands, yum)
	regex.match("^[a-zA-Z]", packages[j]) == true

	not dockerLib.withVersion(packages[j])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, commands]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instruction with 'pip/pip3 install <package>' should use package pinning form 'pip/pip3 install <package>=<version>'",
		"keyActualValue": sprintf("RUN instruction %s does not use package pinning form", [commands]),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) > 1

	isPip(resource.Value)

	resource.Value[j] != "install"
	resource.Value[j] != "pip"
	resource.Value[j] != "pip3"

	regex.match("^[a-zA-Z]", resource.Value[j]) == true
	not dockerLib.withVersion(resource.Value[j])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instruction with 'pip/pip3 install <package>' should use package pinning form 'pip/pip3 install <package>=<version>'",
		"keyActualValue": sprintf("RUN instruction %s does not use package pinning form", [resource.Value[j]]),
	}
}

isPip(command) {
	pip := {"pip", "pip3"}
	contains(command[x], pip[z])
	contains(command[j], "install")
}
