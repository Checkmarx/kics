package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "from"
	not resource.Value[0] == "scratch"
	contains(resource.Value[0], ":latest")

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}", [from_command, name]),
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": sprintf("FROM %s:'version' where version should not be 'latest'", [resource.Value[0]]),
		"keyActualValue": sprintf("FROM %s'", [resource.Value[0]]),
	}
}
