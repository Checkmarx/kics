package Cx

CxPolicy[result] {
	resource := input.document[i].command[name]
	not contains(resource, "healthcheck")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}", [name]),
		"issueType": "MissingAttribute", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": "Dockerfile contains instruction 'HEALTHCHECK'",
		"keyActualValue": "Dockerfile doesn't contain instruction 'HEALTHCHECK'",
	}
}

contains(cmd, elem) {
	cmd[_].Cmd = elem
}
