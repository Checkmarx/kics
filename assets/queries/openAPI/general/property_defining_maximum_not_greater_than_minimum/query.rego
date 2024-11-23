package Cx

import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	openapi_lib.is_numeric_type(value.type)
	minimum := value.minimum
	maximum := value.maximum
	minimum > maximum

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Numeric schema value should not have 'minimum' larger than 'maximum'",
		"keyActualValue": "Numeric schema value has 'minimum' larger than 'maximum'",
		"overrideKey": version,
	}
}

CxPolicy[result] {
	some doc in input.document
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	value.type == "string"
	minimum := value.minLength
	maximum := value.maxLength
	minimum > maximum

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "String schema value should not have 'minLength' larger than 'maxLength'",
		"keyActualValue": "String schema value has 'minLength' larger than 'maxLength'",
		"overrideKey": version,
	}
}

CxPolicy[result] {
	some doc in input.document
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	value.type == "array"
	minimum := value.minItems
	maximum := value.maxItems
	minimum > maximum

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Array schema value should not have 'minItems' larger than 'maxItems'",
		"keyActualValue": "Array schema value has 'minItems' larger than 'maxItems'",
		"overrideKey": version,
	}
}
