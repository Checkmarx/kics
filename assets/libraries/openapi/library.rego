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

# It verifies if there is some schema in 'components.schemas' equal to the input with the 'field' undefined
check_content(doc, s, field) {
	component_schema := doc.components.schemas[sc]
	sc == s
	object.get(component_schema, field, "undefined") == "undefined"
}

# It verifies if the 'schema_ref' refers to a schema with the 'field' undefined
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

# It verifies if there is some schema of 'type' in 'components.schemas' equal to the input with the 'field' undefined
check_schema(doc, s, type, field) {
	component_schema := doc.components.schemas[sc]
	sc == s
	component_schema.properties[p].type == type
	object.get(component_schema.properties[p], field, "undefined") == "undefined"
}

# It verifies if a schema of 'type' has the 'field' undefined. In the case of being a reference, it is necessary to check the referenced schema
undefined_properties_in_schema(doc, value, sc_kind, type, field) {
	sc_kind == "schema"
	schema := value[sc_kind]
	is_ref(schema)
	r := split(schema["$ref"], "/")
	count(r) == 4
	s := r[3]
	check_schema(doc, s, type, field)
}

# It verifies if a schema of 'type' has the 'field' undefined
undefined_properties_in_schema(doc, value, sc_kind, type, field) {
	sc_kind == "schema"
	schema := value[sc_kind]
	not is_ref(schema)
	schema.properties[p].type == type
	object.get(schema.properties[p], field, "undefined") == "undefined"
}

# It verifies if schemas element of 'type' has the 'field' undefined
undefined_properties_in_schema(doc, value, sc_kind, type, field) {
	sc_kind == "schemas"
	schema := value[sc_kind][s]
	not is_ref(schema)
	schema.properties[p].type == type
	object.get(schema.properties[p], field, "undefined") == "undefined"
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

# It verifies what kind of schema is set in the 'value'
get_schema(value) = schema_kind {
	object.get(value, "schemas", "undefined") != "undefined"
	schema_kind := "schemas"
} else = schema_kind {
	object.get(value, "schema", "undefined") != "undefined"
	schema_kind := "schema"
}
