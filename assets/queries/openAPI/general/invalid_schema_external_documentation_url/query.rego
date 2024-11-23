package Cx

import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] = walk(doc)
	url := value.schema.externalDocs.url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.schema.externalDocs.url", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema External Documentation URL should be a valid URL",
		"keyActualValue": "Schema External Documentation URL is not a valid URL",
		"overrideKey": version,
	}
}

CxPolicy[result] {
	some doc in input.document
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	schemaInfo := openapi_lib.get_schema_info(doc, version)
	url := schemaInfo.obj[s].externalDocs.url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.{{%s}}.externalDocs.url", [schemaInfo.path, s]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema External Documentation URL should be a valid URL",
		"keyActualValue": "Schema External Documentation URL is not a valid URL",
		"overrideKey": version,
	}
}
