package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	commands := resource.Value[0]

	yum := regex.find_n("yum (-(-)?[a-zA-Z]+ *)*(group|local)?install", commands, -1)
	yum != null

	packages = dockerLib.getPackages(commands, yum)
	regex.match("^[a-zA-Z]", packages[j]) == true

	not dockerLib.withVersion(packages[j])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, commands]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The package version should always be specified when using zypper install",
		"keyActualValue": sprintf("No version is specified in package '%s'", [packages[j]]),
	}
}
