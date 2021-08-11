package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	server := doc.servers[s]
	variables_undefined(server)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("servers.url=%s", [server.url]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("servers.{{%d}}.url uses server object variables defined in the server object variables", [s]),
		"keyActualValue": sprintf("servers.{{%d}}.url does not use server object variables defined in the server object variables", [s]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	server := doc.paths[path][operation].servers[s]
	variables_undefined(server)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.servers.url=%s", [path, operation, server.url]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.servers.{{%d}}.url uses server object variables defined in the server object variables", [path, operation, s]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.servers.{{%d}}.url does not use server object variables defined in the server object variables", [path, operation, s]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	server := doc.paths[path].servers[s]
	variables_undefined(server)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.servers.url=%s", [path, server.url]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.servers.{{%d}}.url uses server object variables defined in the server object variables", [path, s]),
		"keyActualValue": sprintf("paths.{{%s}}.servers.{{%d}}.url does not use server object variables defined in the server object variables", [path, s]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	server := doc.components.links[l].server
	variables_undefined(server)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.links.{{%s}}.server.url", [l]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.links.{{%s}}.server.url uses server object variables defined in the server object variables", [l]),
		"keyActualValue": sprintf("components.links.{{%s}}.server.url does not use server object variables defined in the server object variables", [l]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	server := doc.components.responses[r].links[l].server
	variables_undefined(server)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.links.{{%s}}.server.url", [r, l]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.responses.{{%s}}.links.{{%s}}.server.url uses server object variables defined in the server object variables", [r, l]),
		"keyActualValue": sprintf("components.responses.{{%s}}.links.{{%s}}.server.url does not use server object variables defined in the server object variables", [r, l]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	server := doc.paths[path][operation].responses[r].links[l].server
	openapi_lib.content_allowed(operation, r)

	variables_undefined(server)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.links.{{%s}}.server.url", [path, operation, r, l]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.links.{{%s}}.server.url uses server object variables defined in the server object variables", [path, operation, r, l]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.links.{{%s}}.server.url does not use server object variables defined in the server object variables", [path, operation, r, l]),
	}
}

variables_undefined(server) {
	url := server.url
	url_variables := regex.find_n("{[a-zA-Z]+}", url, -1)
	url_variables != []
	not common_lib.valid_key(server, "variables")
}

variables_undefined(server) {
	url := server.url
	url_variables := regex.find_n("{[a-zA-Z]+}", url, -1)
	url_variables != []
	var := replace(url_variables[j], "{", "")
	clean_var := replace(var, "}", "")
	not common_lib.valid_key(server.variables, clean_var)
}
