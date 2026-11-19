package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)

	headerObj := value.headers[header]
	# "headers" inside "properties" is a schema field name, not a map of Header Objects
	not path[count(path) - 1] == "properties"
	not common_lib.valid_key(headerObj, "schema")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.{{%s}}", [openapi_lib.concat_path(path), header]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.{{%s}} has schema defined", [openapi_lib.concat_path(path), header]),
		"keyActualValue": sprintf("%s.{{%s}} does not have schema defined", [openapi_lib.concat_path(path), header]),
	}
}
