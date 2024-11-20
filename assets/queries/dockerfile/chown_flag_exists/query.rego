package Cx

import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.command[name]

	contains(resource[j].Flags[f], "--chown")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource[j].Original]),
		"category": "Best Practices",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The 'Dockerfile' shouldn´t contain the 'chown' flag",
		"keyActualValue": "The 'Dockerfile' contains the 'chown' flag",
	}
}
