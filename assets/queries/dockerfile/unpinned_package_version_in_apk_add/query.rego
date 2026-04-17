package Cx

import data.generic.common as common_lib
import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][cmd]
	resource.Cmd == "run"

	count(resource.Value) == 1
	commands := resource.Value[0]

	virtual := regex.find_n("\\-\\-virtual\\s.?[a-zA-Z\\-]+\\s", commands, -1)
	commands_trim = replace(commands, virtual[0],"")
	apk := regex.find_n("apk (-(-)?[a-zA-Z]+ *)*add", commands_trim, -1)
	apk != null

	packages = dockerLib.getPackages(commands_trim, apk)

	length := count(packages)

	some j
	analyzePackages(j, packages[j], packages, length)

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, resource.Original]), from_command.LineHint),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instruction with 'apk add <package>' should use package pinning form 'apk add <package>=<version>'",
		"keyActualValue": sprintf("RUN instruction %s does not use package pinning form", [resource.Value[0]]),
		"searchLine": common_lib.build_search_line(["command", name, cmd], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][cmd]
	resource.Cmd == "run"

	count(resource.Value) == 1
	commands := resource.Value[0]

	virtual := regex.find_n("\\-t\\s.?[a-zA-Z\\-]+\\s", commands, -1)
	commands_trim = replace(commands, virtual[0],"")
	apk := regex.find_n("apk (-(-)?[a-zA-Z]+ *)*add", commands_trim, -1)
	apk != null

	packages = dockerLib.getPackages(commands_trim, apk)

	length := count(packages)

	some j
	analyzePackages(j, packages[j], packages, length)

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, resource.Original]), from_command.LineHint),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instruction with 'apk add <package>' should use package pinning form 'apk add <package>=<version>'",
		"keyActualValue": sprintf("RUN instruction %s does not use package pinning form", [resource.Value[0]]),
		"searchLine": common_lib.build_search_line(["command", name, cmd], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][cmd]
	resource.Cmd == "run"

	count(resource.Value) == 1
	commands := resource.Value[0]
	not regex.match("\\-\\-virtual\\s.?[a-zA-Z\\-]+\\s", commands)
	not regex.match("\\-t\\s.?[a-zA-Z\\-]+\\s", commands)
	apk := regex.find_n("apk (-(-)?[a-zA-Z]+ *)*add", commands, -1)
	apk != null

	packages = dockerLib.getPackages(commands, apk)

	length := count(packages)

	some j
	analyzePackages(j, packages[j], packages, length)

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, resource.Original]), from_command.LineHint),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instruction with 'apk add <package>' should use package pinning form 'apk add <package>=<version>'",
		"keyActualValue": sprintf("RUN instruction %s does not use package pinning form", [resource.Value[0]]),
		"searchLine": common_lib.build_search_line(["command", name, cmd], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][cmd]
	resource.Cmd == "run"

	count(resource.Value) > 1

	dockerLib.arrayContains(resource.Value, {"apk", "add"})

	resource.Value[j] != "apk"
	resource.Value[j] != "add"

	regex.match("^[a-zA-Z]", resource.Value[j])
	not dockerLib.withVersion(resource.Value[j])

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, resource.Original]), from_command.LineHint),
		"searchValue": resource.Value[j],
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instruction with 'apk add <package>' should use package pinning form 'apk add <package>=<version>'",
		"keyActualValue": sprintf("RUN instruction %s does not use package pinning form", [resource.Value[j]]),
		"searchLine": common_lib.build_search_line(["command", name, cmd], []),
	}
}

analyzePackages(j, currentPackage, packages, length) {
	j == length - 1
	regex.match("^[a-zA-Z]", currentPackage)
	not dockerLib.withVersion(currentPackage)
}

analyzePackages(j, currentPackage, packages, length) {
	j != length - 1
	regex.match("^[a-zA-Z]", currentPackage)
	packages[plus(j, 1)] != "-v"
	not dockerLib.withVersion(currentPackage)
}
