package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.paths[name].parameters[n]

	multiple_entries(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.%s.parameters", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.%s.parameters.%d.content has one entry", [name, n]),
		"keyActualValue": sprintf("paths.%s.parameters.%d.content has multiple entries", [name, n]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.paths[name][oper].parameters[n]

	multiple_entries(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.%s.%s.parameters", [name, oper]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("openapi.paths.%s.%s.parameters.%d.content has one entry", [name, oper, n]),
		"keyActualValue": sprintf("openapi.paths.%s.%s.parameters.%d.content has multiple entries", [name, oper, n]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.components.parameters[n]

	multiple_entries(params)

	result := {
		"documentId": doc.id,
		"searchKey": "components.parameters",
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.parameters.%s.content has one entry", [n]),
		"keyActualValue": sprintf("components.parameters.%s.content has multiple entries", [n]),
	}
}

multiple_entries(params) {
	count(params.content) > 1
}
