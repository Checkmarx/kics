package Cx

import data.generic.common as common_lib
import data.generic.dockerfile as docker_lib

CxPolicy[result] {
	resource := input.document[i].command[name][cmd]
	resource.Cmd == "run"

	count(resource.Value) == 1
	commands := resource.Value[0]

	yum := regex.find_n("yum (-(-)?[a-zA-Z]+ *)*(group|local)?install", commands, -1)
	yum != null

	packages = docker_lib.getPackages(commands, yum)
	length := count(packages)

	some j
	analyzePackages(j, packages[j], packages, length)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"searchValue": packages[j],
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The package version should always be specified when using yum install",
		"keyActualValue": sprintf("No version is specified in package '%s'", [packages[j]]),
		"searchLine": common_lib.build_search_line(["command", name, cmd], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][cmd]
	resource.Cmd == "run"

	count(resource.Value) > 1

	docker_lib.arrayContains(resource.Value, {"yum", "install"})

	resource.Value[j] != "install"
	resource.Value[j] != "yum"
	regex.match("^[a-zA-Z]", resource.Value[j]) == true
	not docker_lib.withVersion(resource.Value[j])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"searchValue": resource.Value[j],
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The package version should always be specified when using yum install",
		"keyActualValue": sprintf("No version is specified in package '%s'", [resource.Value[j]]),
		"searchLine": common_lib.build_search_line(["command", name, cmd], []),
	}
}

analyzePackages(j, currentPackage, packages, length) {
	j == length - 1
	regex.match("^[a-zA-Z]", currentPackage) == true
	not docker_lib.withVersion(currentPackage)
}

analyzePackages(j, currentPackage, packages, length) {
	j != length - 1
	regex.match("^[a-zA-Z]", currentPackage) == true
	packages[plus(j, 1)] != "-v"
	not docker_lib.withVersion(currentPackage)
}
