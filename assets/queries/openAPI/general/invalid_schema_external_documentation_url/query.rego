package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] = walk(doc)
	url := value.schema.externalDocs.url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.schema.externalDocs.url", [common_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema External Documentation URL is a valid URL",
		"keyActualValue": "Schema External Documentation URL is not a valid URL",
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version == "3.0"

	url := doc.components.schemas[s].externalDocs.url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.schemas.{{%s}}.externalDocs.url", [s]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema External Documentation URL is a valid URL",
		"keyActualValue": "Schema External Documentation URL is not a valid URL",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version == "2.0"

	url := doc.definitions[s].externalDocs.url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("definitions.{{%s}}.externalDocs.url", [s]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema External Documentation URL is a valid URL",
		"keyActualValue": "Schema External Documentation URL is not a valid URL",
		"overrideKey": version,
	}
}
