package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)
	param := value.parameters[n]
	param.collectionFormat == "multi"
	param.in != "query"
	param.in != "formData"

	searchKey := openapi_lib.concat_default_value(openapi_lib.concat_path(path), "parameters")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.name=%s.in", [searchKey, param.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'in' field should be 'query' or 'formData'",
		"keyActualValue": sprintf("'in' field is %s", [param.in]),
	}
}
