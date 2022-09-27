package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	run_command := resource.Value[_]
	values := split(run_command, " ")
	trim_space(values[0]) == "cd"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Using WORKDIR to change directory",
		"keyActualValue": sprintf("RUN %s'", [resource.Value[0]]),
	}
}
