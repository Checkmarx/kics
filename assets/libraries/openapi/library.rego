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

is_ref(schema) {
	count(schema) == 1
	object.get(schema, "$ref", "undefined") != "undefined"
}

check_string_schema(doc, s, type, field) {
	component_schema := doc.components.schemas[sc]
	sc == s
	component_schema.properties[p].type == type
	object.get(component_schema.properties[p], field, "undefined") == "undefined"
}

undefined_properties_in_schema(doc, schema, type, field) {
	is_ref(schema)
	r := split(schema["$ref"], "/")
	count(r) == 4
	s := r[3]
	check_string_schema(doc, s, type, field)
}

undefined_properties_in_schema(doc, schema, type, field) {
	not is_ref(schema)
	schema.type == type
	object.get(schema, field, "undefined") == "undefined"
}
