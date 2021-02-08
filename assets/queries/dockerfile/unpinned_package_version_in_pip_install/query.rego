package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	commands := resource.Value[0]

	yum := regex.find_n("pip (-(-)?[a-zA-Z]+ *)*install", commands, -1)
	yum != null

	packages = dockerLib.getPackages(commands, yum)
	regex.match("^[a-zA-Z]", packages[j]) == true

	not dockerLib.withVersion(packages[j])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, commands]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instruction with 'pip install <package>' should use package pinning form 'pip install <package>=<version>'",
		"keyActualValue": sprintf("RUN instruction %s does not use package pinning form", [commands]),
	}
}
