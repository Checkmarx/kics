package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	objects := {"paths", "info"}

	object.get(doc, objects[x], "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": "openapi",
		"issueType": "Missing Attribute",
		"keyExpectedValue": sprintf("'%s' is set", [objects[x]]),
		"keyActualValue": sprintf("'%s' is undefined", [objects[x]]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	fields := {"title", "version"}
	check_field(doc.info, fields[x])

	result := {
		"documentId": doc.id,
		"searchKey": "info",
		"issueType": "Missing Attribute",
		"keyExpectedValue": sprintf("'info.%s' is set", [fields[x]]),
		"keyActualValue": sprintf("'info.%s' is undefined", [fields[x]]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	op := doc.paths[path][operation]
	operations := {"get", "post", "put", "delete", "options", "head", "patch", "trace"}
	operation == operations[x]

	check_field(op, "responses")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.{{%s}}.{{%s}}", [path, operation]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("openapi.paths.%s.%s.responses is set", [path, operation]),
		"keyActualValue": sprintf("openapi.paths.%s.%s.responses is undefined", [path, operation]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	scheme := doc.components.securitySchemes[s]
	security_scheme_fields := {"name", "type", "in", "scheme", "flows", "openIdConnectUrl"}

	check_field(scheme, security_scheme_fields[x])

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.components.securitySchemes.{{%s}}", [s]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("openapi.components.securitySchemes.%s.%s is set", [s, security_scheme_fields[x]]),
		"keyActualValue": sprintf("openapi.components.securitySchemes.%s.%s is undefined", [s, security_scheme_fields[x]]),
	}
}

parameter_fields := {"name", "in", "required"}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.paths[name].parameters[n]

	check_field(params, parameter_fields[x])

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.{{%s}}.parameters", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("openapi.paths.%s.parameters.%d.%s is set", [name, n, parameter_fields[x]]),
		"keyActualValue": sprintf("openapi.paths.%s.parameters.%d.%s is undefined", [name, n, parameter_fields[x]]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.paths[name][oper].parameters[n]

	check_field(params, parameter_fields[x])

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.%s.%s.parameters", [name, oper]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("openapi.paths.%s.%s.parameters.%d.%s is set", [name, oper, n, parameter_fields[x]]),
		"keyActualValue": sprintf("openapi.paths.%s.%s.parameters.%d.%s is undefined", [name, oper, n, parameter_fields[x]]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.components.parameters[n]

	check_field(params, parameter_fields[x])

	result := {
		"documentId": doc.id,
		"searchKey": "openapi.components.parameters",
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("openapi.components.parameters.%d.%s is set", [n, parameter_fields[x]]),
		"keyActualValue": sprintf("openapi.components.parameters.%d.%s is undefined", [n, parameter_fields[x]]),
	}
}

check_field(field, value) {
	field != null
	object.get(field, value, "undefined") == "undefined"
}

check_field(field, values) {
	field == null
}
