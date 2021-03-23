package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) == 1
	values := resource.Value[0]

	hasCacheFlag(values)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, values]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The '--no-cache-dir' flag is set when running 'pip/pip3 install'",
		"keyActualValue": "The '--no-cache-dir' flag isn't set when running 'pip/pip3 install'",
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) > 1

	isPip(resource.Value)

	not hasCacheFlagInList(resource.Value)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The '--no-cache-dir' flag is set when running 'pip/pip3 install'",
		"keyActualValue": "The '--no-cache-dir' flag isn't set when running 'pip/pip3 install'",
	}
}

hasCacheFlag(values) {
	commands = split(values, "&&")

	some i
	instruction := commands[i]
	regex.match("pip(3)? (-(-)?[a-zA-Z]+ *)*install", instruction) == true
	not contains(instruction, "--no-cache-dir")
}

isPip(commands) {
	pip := {"pip", "pip3"}
	commands[j] == pip[x]
}

hasCacheFlagInList(commands) {
	contains(commands[j], "--no-cache-dir")
}
