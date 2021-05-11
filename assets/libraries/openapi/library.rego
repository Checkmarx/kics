package generic.openapi

check_openapi(doc) = version {
	object.get(doc, "openapi", "undefined") != "undefined"
	version = doc.openapi
	regex.match("^3\\.0\\.\\d+$", doc.openapi)
} else = version {
	version = "undefined"
}

is_valid_url(url) {
	regex.match(`^(https?):\/\/(-\.)?([^\s\/?\.#-]+([-\.\/])?)+(\/[^\s]*)?$`, url)
}

improperly_defined(params, value) {
	params.in == "header"
	params.name == value
}

incorrect_ref(ref, object) {
	references := {
		"schema": "#/components/schemas/",
		"responses": "#/components/responses/",
		"requestBody": "#/components/requestBodies/",
		"links": "#/components/links/",
		"callbacks": "#/components/callbacks/",
	}

	regex.match(references[object], ref) == false
}

content_allowed(operation, code) {
	operation != "head"
	all([code != "204", code != "304"])
}

check_content(doc, s, field) {
	component_schema := doc.components.schemas[sc]
	sc == s
	object.get(component_schema, field, "undefined") == "undefined"
}

undefined_field_in_json_object(doc, schema_ref, field) {
	r := split(schema_ref, "/")
	count(r) == 4
	s := r[3]
	check_content(doc, s, field)
}

check_reference_exists(doc, referenceName, type) {
	ref := sprintf("#/components/%s/%s", [type, referenceName])

	count({ref | [_, value] := walk(doc); ref == value["$ref"]}) == 0
}
