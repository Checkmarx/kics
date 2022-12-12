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
		"keyExpectedValue": "The Schema Object should not be empty",
		"keyActualValue": "The Schema Object is empty",
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	schemaInfo := openapi_lib.get_schema_info(doc, version)
	schemaInfo.obj[s] == options[x]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.{{%s}}", [schemaInfo.path, s]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The Schema Object should not be empty",
		"keyActualValue": "The Schema Object is empty",
		"overrideKey": version,
	}
}
