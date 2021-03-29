package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) == 1
	commands := resource.Value[0]

	zypper := regex.find_n("zypper (-(-)?[a-zA-Z]+ *)*in(stall)?", commands, -1)
	zypper != null

	packages = dockerLib.getPackages(commands, zypper)
	length := count(packages)

	some j
	analyzePackages(j, packages[j], packages, length)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The package version should always be specified when using zypper install",
		"keyActualValue": sprintf("No version is specified in package '%s'", [packages[j]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) > 1

    dockerLib.arrayContains(resource.Value, {"zypper", "install"})

	resource.Value[j] != "install"
	resource.Value[j] != "zypper"
	regex.match("^[a-zA-Z]", resource.Value[j]) == true
	not dockerLib.withVersion(resource.Value[j])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The package version should always be specified when using zypper install",
		"keyActualValue": sprintf("No version is specified in package '%s'", [resource.Value[j]]),
	}
}

analyzePackages(j, currentPackage, packages, length) {
	j == length - 1
	regex.match("^[a-zA-Z]", currentPackage) == true
	not dockerLib.withVersion(currentPackage)
}

analyzePackages(j, currentPackage, packages, length) {
	j != length - 1
	regex.match("^[a-zA-Z]", currentPackage) == true
	packages[plus(j, 1)] != "-v"
	not dockerLib.withVersion(currentPackage)
}
