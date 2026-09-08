package Cx

import data.generic.dockerfile as dockerLib

flags = ["-r", "-c"]

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) == 1
	commands := resource.Value[0]

	yum := regex.find_n("pip(3)? (-(-)?[a-zA-Z]+ *)*install", commands, -1)
	yum != null

	packages = dockerLib.getPackages(commands, yum)
	refactorPackages = [ x | x := packages[_]; x != ""]

	count({x | x := refactorPackages[_]; x == flags[_]}) == 0

	cleanPackages = [ p |
		some k
		p := refactorPackages[k]
		not startswith(p, "-")
		not contains(p, "://")
		not contains(p, "/")
		not isFlagArgument(refactorPackages, k)
	]
	length := count(cleanPackages)

	some j
	analyzePackages(j, cleanPackages[j], cleanPackages, length)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
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

	not contains(resource.Value[j], "://")
	not contains(resource.Value[j], "/")
	not isFlagArgument(resource.Value, j)

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

analyzePackages(j, currentPackage, _, length) {
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

isFlagArgument(arr, k) {
	k > 0
	regex.match("^-", arr[k - 1])
	not startswith(arr[k], "-")
	regex.match(`[.:/]`, arr[k])
}