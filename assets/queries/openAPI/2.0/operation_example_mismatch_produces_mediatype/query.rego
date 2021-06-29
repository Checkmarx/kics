package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	op := doc.paths[path][operation]
	response := op.responses[status]
	response.examples[mimeType]

	produces := get_produces(op, doc)

	not common_lib.inArray(produces, mimeType)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.%s.responses.{{%s}}.examples.{{%s}}", [path, operation, status, mimeType]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Example MimeType is listed on produces",
		"keyActualValue": "Example MimeType is not listed on produces",
	}
}

get_produces(op, doc) = result {
	object.get(op, "produces", "undefined") != "undefined"
	result := op.produces
} else = result {
	object.get(doc, "produces", "undefined") != "undefined"
	result := doc.produces
} else = result {
	result := []
}
