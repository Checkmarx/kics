package Cx

import data.generic.common as common_lib
import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][cmd]
	resource.Cmd == "run"

	count(resource.Value) == 1
	commands := resource.Value[0]

	zypper := regex.find_n("zypper (-(-)?[a-zA-Z]+ *)*in(stall)?", commands, -1)
	zypper != null

	packages = dockerLib.getPackages(commands, zypper)
	length := count(packages)

	some j
	analyzePackages(j, packages[j], packages, length)

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, resource.Original]), from_command.EndLine-1),
		"searchValue": packages[j],
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The package version should always be specified when using zypper install",
		"keyActualValue": sprintf("No version is specified in package '%s'", [packages[j]]),
		"searchLine": common_lib.build_search_line(["command", name, cmd], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][cmd]
	resource.Cmd == "run"

	count(resource.Value) > 1

	dockerLib.arrayContains(resource.Value, {"zypper", "install"})

	resource.Value[j] != "install"
	resource.Value[j] != "zypper"
	regex.match("^[a-zA-Z]", resource.Value[j]) == true
	not dockerLib.withVersion(resource.Value[j])

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, resource.Original]), from_command.EndLine-1),
		"searchValue": resource.Value[j],
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The package version should always be specified when using zypper install",
		"keyActualValue": sprintf("No version is specified in package '%s'", [resource.Value[j]]),
		"searchLine": common_lib.build_search_line(["command", name, cmd], []),
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
