package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	schema_ref = value.schema["$ref"]
	openapi_lib.undefined_field_in_json_object(doc, schema_ref, "type")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.schema.$ref", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Schema of the JSON object has 'type' defined",
		"keyActualValue": "Schema of the JSON object does not have 'type' defined",
	}
}
