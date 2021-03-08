package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) == 1
	commands := resource.Value[0]

	yum := regex.find_n("pip (-(-)?[a-zA-Z]+ *)*install", commands, -1)
	yum != null

	packages = dockerLib.getPackages(commands, yum)
	length := count(packages)

	some j
	analyzePackages(j, packages[j], packages, length)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instruction with 'pip install <package>' should use package pinning form 'pip install <package>=<version>'",
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
	regex.match("^[a-zA-Z]", resource.Value[j]) == true
	not dockerLib.withVersion(resource.Value[j])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instruction with 'pip install <package>' should use package pinning form 'pip install <package>=<version>'",
		"keyActualValue": sprintf("RUN instruction %s does not use package pinning form", [resource.Value[j]]),
	}
}

isPip(command) {
	contains(command[x], "pip")
	contains(command[j], "install")
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
