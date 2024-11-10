package Cx

import data.generic.dockerfile as dockerLib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.command[name][_]
	resource.Cmd == "run"

	count(resource.Value) == 1
	values := resource.Value[0]

	hasCacheFlag(values)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, values]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The '--no-cache-dir' flag should be set when running 'pip/pip3 install'",
		"keyActualValue": "The '--no-cache-dir' flag isn't set when running 'pip/pip3 install'",
	}
}

CxPolicy[result] {
	some doc in input.document
	resource := doc.command[name][_]
	resource.Cmd == "run"

	count(resource.Value) > 1

	isPip(resource.Value)

	not hasCacheFlagInList(resource.Value)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The '--no-cache-dir' flag should be set when running 'pip/pip3 install'",
		"keyActualValue": "The '--no-cache-dir' flag isn't set when running 'pip/pip3 install'",
	}
}

hasCacheFlag(values) {
	commands = dockerLib.getCommands(values)

	some i
	instruction := commands[i]
	regex.match(`pip(3)? (-(-)?[a-zA-Z]+ *)*install`, instruction) == true
	not contains(instruction, "--no-cache-dir")
}

isPip(commands) {
	pip := {"pip", "pip3"}
	commands[j] == pip[x]
}

hasCacheFlagInList(commands) {
	contains(commands[j], "--no-cache-dir")
}
