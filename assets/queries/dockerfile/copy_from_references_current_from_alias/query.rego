package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "copy"

	contains(resource.Flags[x], "--from=")
	aux_split := split(resource.Flags[x], "=")

	isAliasCurrentFromAlias(name, aux_split[1])

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}.{{%s}}", [from_command, name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "COPY --from should not reference the current FROM alias",
		"keyActualValue": "COPY --from references the current FROM alias",
	}
}

isAliasCurrentFromAlias(currentName, currentAlias) = allow {
	resource := input.document[i].command[name][_]
	currentName == name

	resource.Cmd == "from"
	previousAlias := resource.Value[2]

	previousAlias == currentAlias

	allow = true
}
