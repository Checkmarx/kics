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
    length := count(refactorPackages)

	count({x | x := refactorPackages[_]; x == flags[_]}) == 0

	some j
	analyzePackages(j, refactorPackages[j], packages, length)

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, resource.Original]), from_command.EndLine-1),
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

	regex.match("^[a-zA-Z]", resource.Value[j]) == true
	not dockerLib.withVersion(resource.Value[j])

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, resource.Original]), from_command.EndLine-1),
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
