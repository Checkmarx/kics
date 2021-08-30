package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)

	headerObj := value.headers[header]
	not common_lib.valid_key(headerObj, "schema")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.{{%s}}", [openapi_lib.concat_path(path), header]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.{{%s}} has schema defined", [openapi_lib.concat_path(path), header]),
		"keyActualValue": sprintf("%s.{{%s}} does not have schema defined", [openapi_lib.concat_path(path), header]),
	}
}
