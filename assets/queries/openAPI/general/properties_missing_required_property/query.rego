package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	prop := value.properties
	req := prop[name].required
	some requiredProperty in req
	properties := prop[name].properties
	not common_lib.valid_key(properties, requiredProperty)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.properties.%s.required.%s", [openapi_lib.concat_path(path), name, requiredProperty]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.properties.%s.required.%s should be defined", [openapi_lib.concat_path(path), name, requiredProperty]),
		"keyActualValue": sprintf("%s.properties.%s.required.%s is missing", [openapi_lib.concat_path(path), name, requiredProperty]),
		"overrideKey": version,
	}
}
