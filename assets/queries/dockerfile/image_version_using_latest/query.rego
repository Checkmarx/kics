package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "from"
	not resource.Value[0] == "scratch"
	contains(resource.Value[0], ":latest")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}", [name]),
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": sprintf("FROM %s:'version' where version should not be 'latest'", [resource.Value[0]]),
		"keyActualValue": sprintf("FROM %s'", [resource.Value[0]]),
	}
}
