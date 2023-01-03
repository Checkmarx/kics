package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) == 1
	commands := resource.Value[0]

	dnf := regex.find_n("dnf (-(-)?[a-zA-Z]+ *)*(in|rei)n?(stall)?", commands, -1)
	dnf != null

	packages = dockerLib.getPackages(commands, dnf)

	length := count(packages)

	some j
	analyzePackages(j, packages[j], packages, length)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Package version should be specified when using 'dnf install'",
		"keyActualValue": "Package version should be pinned when running ´dnf install´",
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) > 1

	isDnf(resource.Value)

	resource.Value[j] != "dnf"
	regex.match("(in|rei)n?(stall)?", resource.Value[j]) == false

	regex.match("^[a-zA-Z]", resource.Value[j]) == true
	not dockerLib.withVersion(resource.Value[j])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Package version should be specified when using 'dnf install'",
		"keyActualValue": "Package version should be pinned when running ´dnf install´",
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

isDnf(command) {
	contains(command[x], "dnf")
	regex.match("(in|rei)n?(stall)?", command[j]) == true
}
