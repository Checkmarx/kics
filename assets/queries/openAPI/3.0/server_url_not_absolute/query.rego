package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	url := doc.servers[s].url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("servers.url=%s", [url]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("servers.{{%d}}.url has an absolute URL", [s]),
		"keyActualValue": sprintf("servers.{{%d}}.url does not have an absolute URL", [s]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	url := doc.paths[path][operation].servers[s].url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.servers.url=%s", [path, operation, url]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.servers.{{%d}}.url has an absolute URL", [path, operation, s]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.servers.{{%d}}.url does not have an absolute URL", [path, operation, s]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	url := doc.paths[path].servers[s].url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.servers.url=%s", [path, url]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.servers.{{%d}}.url has an absolute URL", [path, s]),
		"keyActualValue": sprintf("paths.{{%s}}.servers.{{%d}}.url does not have an absolute URL", [path, s]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	url := doc.components.links[l].server.url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.links.{{%s}}.server.url", [l]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.links.{{%s}}.server.url has an absolute URL", [l]),
		"keyActualValue": sprintf("components.links.{{%s}}.server.url does not have an absolute URL", [l]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	url := doc.components.responses[r].links[l].server.url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.links.{{%s}}.server.url", [r, l]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.responses.{{%s}}.links.{{%s}}.server.url has an absolute URL", [r, l]),
		"keyActualValue": sprintf("components.responses.{{%s}}.links.{{%s}}.server.url does not have an absolute URL", [r, l]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	url := doc.paths[path][operation].responses[r].links[l].server.url
	openapi_lib.content_allowed(operation, r)
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.links.{{%s}}.server.url", [path, operation, r, l]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.links.{{%s}}.server.url has an absolute URL", [path, operation, r, l]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.links.{{%s}}.server.url does not have an absolute URL", [path, operation, r, l]),
	}
}
