package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "copy"

	contains(resource.Flags[x], "--from=")
	resource.Flags[x] != "--from=0"
	aux_split := split(resource.Flags[x], "=")

	not isPreviousAlias(resource.StartLine, aux_split[1])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "COPY '--from' references a previous defined FROM alias",
		"keyActualValue": "COPY '--from' does not reference a previous defined FROM alias",
	}
}

isPreviousAlias(startLine, currentAlias) = allow {
	resource := input.document[i].command[name][_]
	resource.Cmd == "from"
	previousAlias := resource.Value[2]

	previousAlias == currentAlias
	resource.EndLine < startLine

	allow = true
}
