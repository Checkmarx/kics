package Cx

import data.generic.openapi as openapi_lib

options := {{}, null}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] = walk(doc)
	value.schema == options[x]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.schema", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The Schema Object is not empty",
		"keyActualValue": "The Schema Object is empty",
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version == "3.0"

	schema := doc.components.schemas[s]
	schema == options[x]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.schemas.{{%s}}", [s]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The Schema Object is not empty",
		"keyActualValue": "The Schema Object is empty",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version == "2.0"

	schema := doc.definitions[s]
	schema == options[x]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("definitions.{{%s}}", [s]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The Schema Object is not empty",
		"keyActualValue": "The Schema Object is empty",
		"overrideKey": version,
	}
}
