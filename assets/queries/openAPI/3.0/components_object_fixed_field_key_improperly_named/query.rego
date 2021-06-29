package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	obj := doc.components[field][key]
	not is_alphanumeric(key)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.{{%s}}.{{%s}}", [field, key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.{{%s}}.{{%s}} is properly named", [field, key]),
		"keyActualValue": sprintf("components.{{%s}}.{{%s}}is improperly named", [field, key]),
	}
}

is_alphanumeric(key) {
	regex.match(`^[a-zA-Z0-9\\.\\-_]+$`, key) == true
}
