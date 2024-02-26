package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	schema_ref = value.schema["RefMetadata"]["$ref"]
	openapi_lib.undefined_field_in_json_object(doc, schema_ref, "properties", version)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.schema.$ref", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Schema of the JSON object should have 'properties' defined",
		"keyActualValue": "Schema of the JSON object does not have 'properties' defined",
		"overrideKey": version,
	}
}
