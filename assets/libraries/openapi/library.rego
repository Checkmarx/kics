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

check_unused_reference(doc, referenceName, type) {
	ref := sprintf("#/components/%s/%s", [type, referenceName])

	count({ref | [_, value] := walk(doc); ref == value["$ref"]}) == 0
}

check_reference_unexisting(doc, reference, type) = checkComponents {
	refString := sprintf("#/components/%s/", [type])
	startswith(reference, refString)
	checkComponents := trim_prefix(reference, refString)
	object.get(doc.components[type], checkComponents, "undefined") == "undefined"
}

concat_path(path) = concatenated {
	concatenated := concat(".", [x | x := resolve_path(path[_])])
}

resolve_path(pathItem) = resolved {
	any([contains(pathItem, "."), contains(pathItem, "="), contains(pathItem, "/")])
	resolved := sprintf("{{%s}}", [pathItem])
} else = pathItem {
	true
}
