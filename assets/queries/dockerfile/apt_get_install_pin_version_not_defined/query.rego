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
	length := count(packages)

	packageName := packages[j]
	analyzePackages(j, packageName, packages, length)

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}.RUN={{%s}}", [from_command, name, commands]),
		"searchValue": packageName,
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Package '%s' has version defined", [packageName]),
		"keyActualValue": sprintf("Package '%s' does not have version defined", [packageName]),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) > 1

	dockerLib.arrayContains(resource.Value, {"apt-get", "install"})

	resource.Value[j] != "install"
	resource.Value[j] != "apt-get"

	packageName := resource.Value[j]

	regex.match("^[a-zA-Z]", packageName) == true
	not dockerLib.withVersion(packageName)

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}.{{%s}}", [from_command, name, resource.Original]),
		"searchValue": packageName,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Package '%s' has version defined", [packageName]),
		"keyActualValue": sprintf("Package '%s' does not have version defined", [packageName]),
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
