package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	op := doc.paths[path][operation]
	op.parameters[_].type == "file"
	check_consumes(op)
	check_consumes(doc)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.%s.parameters", [path, operation]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Operation or global 'consumes' field should have declared 'multipart/form-data', 'application/x-www-form-urlencoded' or both when there is a file type parameter",
		"keyActualValue": "Operation or global 'consumes' field doesn't have declared 'multipart/form-data', 'application/x-www-form-urlencoded' or both when there is a file type parameter",
	}
}

check_consumes(obj) {
	obj.consumes[_] != "multipart/form-data"
	obj.consumes[_] != "application/x-www-form-urlencoded"
} else {
	not common_lib.valid_key(obj, "consumes")
}
