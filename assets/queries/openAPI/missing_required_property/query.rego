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

check_field(field, value) {
	field != null
	object.get(field, value, "undefined") == "undefined"
}

check_field(field, values) {
	field == null
}
