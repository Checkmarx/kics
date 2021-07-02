package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	server := doc.servers[s]

	server.variables[x]
	variables_not_used(x, server.url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("servers.variables.{{%s}}", [x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("servers.variables.{{%s}} is used in 'servers[%d].url'", [x, s]),
		"keyActualValue": sprintf("servers.variables.{{%s}} is not used in 'servers[%d].url'", [x, s]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	server := doc.paths[path][operation].servers[s]

	server.variables[x]
	variables_not_used(x, server.url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.servers.variables.{{%s}}", [path, operation, x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.servers.variables.{{%s}} is used in 'paths.{{%s}}.{{%s}}.servers.{{%d}}.url'", [path, operation, x, path, operation, s]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.servers.variables.{{%s}} is not used in 'paths.{{%s}}.{{%s}}.servers.{{%d}}.url '", [path, operation, x, path, operation, s]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	server := doc.paths[path].servers[s]

	server.variables[x]
	variables_not_used(x, server.url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.servers.variables.{{%s}}", [path, x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.servers.variables.{{%s}} is used in 'paths.{{%s}}.servers.{{%d}}.url'", [path, x, path, s]),
		"keyActualValue": sprintf("paths.{{%s}}.servers.variables.{{%s}} is not used in 'paths.{{%s}}.servers.{{%d}}.url'", [path, x, path, s]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	server := doc.components.links[l].server

	server.variables[x]
	variables_not_used(x, server.url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.links.{{%s}}.server.variables.{{%s}}", [l, x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.links.{{%s}}.server.variables.{{%s}} is used in 'components.links.{{%s}}.server.url'", [l, x, l]),
		"keyActualValue": sprintf("components.links.{{%s}}.server.variables.{{%s}} is not used in 'components.links.{{%s}}.server.url'", [l, x, l]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	server := doc.components.responses[r].links[l].server

	server.variables[x]
	variables_not_used(x, server.url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.links.{{%s}}.server.variables.{{%s}}", [r, l, x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.responses.{{%s}}.links.{{%s}}.server.variables.{{%s}} is used in 'components.responses.{{%s}}.links.{{%s}}.server.url'", [r, l, x, r, l]),
		"keyActualValue": sprintf("components.responses.{{%s}}.links.{{%s}}.server.variables.{{%s}} is not used in 'components.responses.{{%s}}.links.{{%s}}.server.url'", [r, l, x, r, l]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	server := doc.paths[path][operation].responses[r].links[l].server
	openapi_lib.content_allowed(operation, r)

	server.variables[x]
	variables_not_used(x, server.url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.links.{{%s}}.server.variables.{{%s}}", [path, operation, r, l, x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.links.{{%s}}.server.variables.{{%s}} is used in 'paths.{{%s}}.{{%s}}.responses.{{%s}}.links.{{%s}}.server.url'", [path, operation, r, l, x, path, operation, r, l]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.links.{{%s}}.server.variables.{{%s}} is not used in 'paths.{{%s}}.{{%s}}.responses.{{%s}}.links.{{%s}}.server.url'", [path, operation, r, l, x, path, operation, r, l]),
	}
}

exists(var, vars) {
	var_in_url := replace(vars[_], "{", "")
	clean_var := replace(var_in_url, "}", "")
	var == clean_var
}

variables_not_used(var, url) {
	url_variables := regex.find_n("{[a-zA-Z]+}", url, -1)
	url_variables != []
	not exists(var, url_variables)
}

variables_not_used(var, url) {
	url_variables := regex.find_n("{[a-zA-Z]+}", url, -1)
	url_variables == []
}
