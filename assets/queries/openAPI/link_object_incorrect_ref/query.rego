package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	link := doc.components.responses[r].links[l]
	openapi_lib.incorrect_ref(link["$ref"], "links")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.links.{{%s}}.$ref={{%s}}", [r, l, link["$ref"]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Link ref points to '#/components/links'",
		"keyActualValue": "Link ref does not point to '#/components/links'",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	link := doc.paths[path][operation].responses[r].links[l]
	openapi_lib.incorrect_ref(link["$ref"], "links")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.links.{{%s}}.$ref={{%s}}", [path, operation, r, l, link["$ref"]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Link ref points to '#/components/links'",
		"keyActualValue": "Link ref does not point to '#/components/links'",
	}
}
