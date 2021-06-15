package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	param := value.parameters[n]
	param.in == "path"
	issueType := not_required(param)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.parameters.name={{%s}}", [openapi_lib.concat_path(path), param.name]),
		"issueType": issueType,
		"keyExpectedValue": "Path parameter has the field 'required' set to 'true' for location 'path'",
		"keyActualValue": "Path parameter does not have the field 'required' set to 'true' for location 'path'",
		"overrideKey": version,
	}
}

not_required(param) = issueType {
	object.get(param, "required", "undefined") == "undefined"
	issueType = "MissingAttribute"
} else = issueType {
	param.required == false
	issueType = "IncorrectValue"
}
