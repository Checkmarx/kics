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
		"schemas": "#/components/schemas/",
		"responses": "#/components/responses/",
		"requestBodies": "#/components/requestBodies/",
		"links": "#/components/links/",
		"callbacks": "#/components/callbacks/",
		"examples": "#/components/examples/",
		"headers": "#/components/headers/",
		"parameters": "#/components/parameters/",
	}

	not startswith(ref, references[object])
}

content_allowed(operation, code) {
	operation != "head"
	all([code != "204", code != "304"])
}

# It verifies if there is some schema in 'components.schemas' equal to the input with the 'field' undefined
check_content(doc, s, field) {
	component_schema := doc.components.schemas[s]
	object.get(component_schema, field, "undefined") == "undefined"
}

# It verifies if the 'schema_ref' refers to a schema with the 'field' undefined
undefined_field_in_json_object(doc, schema_ref, field) {
	r := split(schema_ref, "/")
	count(r) == 4
	s := r[3]
	check_content(doc, s, field)
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
	concatenated := concat(".", [x | x := resolve_path(path[_]); x != ""])
}

resolve_path(pathItem) = resolved {
	any([contains(pathItem, "."), contains(pathItem, "="), contains(pathItem, "/")])
	resolved := sprintf("{{%s}}", [pathItem])
} else = resolved {
	is_number(pathItem)
	resolved := ""
} else = pathItem {
	true
}

# It verifies if the path contains an operation. If true, keeps the operation type and the response code related to it
is_operation(path) = info {
	path[0] == "paths"
	operations := {"get", "post", "put", "delete", "options", "head", "patch", "trace"}
	operations[z] == path[2]
	path[j] == "responses"
	idx := j + 1
	code := path[idx]
	op := operations[z]
	info := {"code": code, "operation": op}
} else = info {
	info := {}
}

is_numeric_type(type) {
	numeric := {"integer", "number"}
	type == numeric[x]
}

# It verifies if the string schema does not have the 'field' defined
undefined_field_in_string_schema(value, field) {
	value.type == "string"
	object.get(value, field, "undefined") == "undefined"
}

# It verifies if the numeric schema does not have the 'field' defined
undefined_field_in_numeric_schema(value, field) {
	is_numeric_type(value.type)
	object.get(value, field, "undefined") == "undefined"
}

# It verifies if the 'field' is consistent with the 'type'
invalid_field(field, type) {
	numeric := {"integer", "number"}
	type == numeric[_]
	not is_number(field)
} else {
	type == "string"
	not is_string(field)
} else {
	type == "boolean"
	not is_boolean(field)
} else {
	type == "object"
	not is_object(field)
} else {
	type == "array"
	not is_array(field)
}
