package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	value["RefMetadata"]["alone"] == false

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Only '$ref' property should be declared or other properties declared without '$ref'",
		"keyActualValue": "Property '$ref'alongside other properties",
		"overrideKey": version,
	}
}
