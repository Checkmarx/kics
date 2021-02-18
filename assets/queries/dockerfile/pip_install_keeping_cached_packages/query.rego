package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	values := resource.Value[0]

	hasCacheFlag(values)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The '--no-cache-dir' flag is set when running 'pip install'",
		"keyActualValue": "The '--no-cache-dir' flag isn't set when running 'pip install'",
	}
}

hasCacheFlag(values) {
	commands = split(values, "&&")

	some i
	instruction := commands[i]
	contains(instruction, "pip install")
	not contains(instruction, "--no-cache-dir")
}
