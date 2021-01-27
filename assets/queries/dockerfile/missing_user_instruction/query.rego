package Cx

CxPolicy[result] {
	resource := input.document[i].command[name]

  not name == "scratch"
  not hasUserInstruction(resource)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}", [name]),
		"issueType": "Missing Attribute",
		"keyExpectedValue": "The 'Dockerfile' contains the 'USER' instruction",
		"keyActualValue": "The 'Dockerfile' does not contain any 'USER' instruction",
	}
}

hasUserInstruction(resource) {
	some j
	resource[j].Cmd == "user"
}
