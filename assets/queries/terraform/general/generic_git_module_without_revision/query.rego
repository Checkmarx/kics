package Cx

CxPolicy[result] {
	module := input.document[i].module[moduleName]
	startswith(module.source, "git::")
	not contains(module.source, "?ref=")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module.{{%s}}.source", [moduleName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Module 'source' field should have a reference",
		"keyActualValue": "Module 'source' field does not have reference",
	}
}
