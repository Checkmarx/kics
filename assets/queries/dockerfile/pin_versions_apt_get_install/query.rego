package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
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
