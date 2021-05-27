package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	prop := value.properties
	req := prop[name].required
	object.get(prop[name].properties, req[p], "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.properties.%s.required.%s", [openapi_lib.concat_path(path), name, req[p]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.properties.%s.required.%s is defined", [openapi_lib.concat_path(path), name, req[p]]),
		"keyActualValue": sprintf("%s.properties.%s.required.%s is missing", [openapi_lib.concat_path(path), name, req[p]]),
	}
}
