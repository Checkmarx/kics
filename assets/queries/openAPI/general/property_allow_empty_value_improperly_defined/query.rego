package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	params := value.parameters[n]
	common_lib.valid_key(params, "allowEmptyValue")
	all([params["in"] != "query", params["in"] != "formData"])

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.parameters.name={{%s}}", [openapi_lib.concat_path(path), params.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'parameters' should have 'in' set to 'query'/'formData' when 'allowEmptyValue' is set",
		"keyActualValue": "'parameters' does not have 'in' set to 'query'/'formData' when 'allowEmptyValue' is set",
		"overrideKey": version,
	}
}
