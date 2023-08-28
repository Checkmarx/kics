package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"
	params := doc.paths[name].parameters[n]
	not common_lib.valid_key(params, "RefMetadata")

	not check_params(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.parameters.name={{%s}}", [name, params.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter Object shouldn't have both 'schema' and 'content' defined",
		"keyActualValue": "Parameter Object has both 'schema' and 'content' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"
	params := doc.paths[name][oper].parameters[n]
	not common_lib.valid_key(params, "RefMetadata")

	not check_params(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.%s.%s.parameters.name={{%s}}", [name, oper, params.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter Object shouldn't have both 'schema' and 'content' defined",
		"keyActualValue": "Parameter Object has both 'schema' and 'content' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"
	params := doc.components.parameters[n]
	not common_lib.valid_key(params, "RefMetadata")

	not check_params(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.components.parameters.name={{%s}}", [params.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter Object shouldn't have both 'schema' and 'content' defined",
		"keyActualValue": "Parameter Object has both 'schema' and 'content' defined",
	}
}

check_params(params) {
    not common_lib.valid_key(params, "schema")
}

check_params(params) {
    not common_lib.valid_key(params, "content")
}
