package Cx

import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.command[name][_]
	resource.Cmd == "from"
	not resource.Value[0] == "scratch"
	contains(resource.Value[0], ":latest")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("FROM={{%s}}", [name]),
		"issueType": "IncorrectValue", # "MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": sprintf("FROM %s:'version' where version should not be 'latest'", [resource.Value[0]]),
		"keyActualValue": sprintf("FROM %s'", [resource.Value[0]]),
	}
}
