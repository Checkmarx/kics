package Cx

CxPolicy[result] {
	resource := input.document[i].command[name]

	contains(resource[j].Flags[f], "--chown")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource[j].Original]),
		"category": "Best Practices",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The 'Dockerfile' shouldn´t contain the 'chown' flag",
		"keyActualValue": "The 'Dockerfile' contains the 'chown' flag",
	}
}
