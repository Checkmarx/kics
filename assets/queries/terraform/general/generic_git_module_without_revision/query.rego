package Cx

import future.keywords.in

CxPolicy[result] {
	some document in input.document
	module := document.module[moduleName]
	startswith(module.source, "git::")
	not contains(module.source, "?ref=")

	result := {
		"documentId": document.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module.{{%s}}.source", [moduleName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Module 'source' field should have a reference",
		"keyActualValue": "Module 'source' field does not have reference",
	}
}
