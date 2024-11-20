package Cx

import future.keywords.in

CxPolicy[result] {
	some document in input.keywords
	resource := document.command[name][_]
	resource.Cmd == "copy"

	contains(resource.Flags[x], "--from=")
	aux_split := split(resource.Flags[x], "=")

	isAliasCurrentFromAlias(name, aux_split[1])

	result := {
		"documentId": document.id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "COPY --from should not reference the current FROM alias",
		"keyActualValue": "COPY --from references the current FROM alias",
	}
}

isAliasCurrentFromAlias(currentName, currentAlias) = allow {
	some document in input.document
	resource := document.command[name][_]
	currentName == name

	resource.Cmd == "from"
	previousAlias := resource.Value[2]

	previousAlias == currentAlias

	allow = true
}
