package generic.openapi

check_openapi(doc) = version {
	object.get(doc, "openapi", "undefined") != "undefined"
	regex.match("^3\\.0\\.\\d+$", doc.openapi)
	version = "3.0"
} else = version {
	object.get(doc, "swagger", "undefined") != "undefined"
	version = "2.0"
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

incorrect_ref_swagger(ref, object) {
	references := {
		"parameters": "#/parameters/",
		"responses": "#/responses/",
		"schemas": "#/definitions/",
	}

	not startswith(ref, references[object])
}

content_allowed(operation, code) {
	operation != "head"
	all([code != "204", code != "304"])
}

# It verifies if there is some schema in 'key' equal to the input with the 'field' undefined
check_content(s, field, key) {
	object.get(key[s], field, "undefined") == "undefined"
}

# It verifies if the 'schema_ref' refers to a schema with the 'field' undefined
undefined_field_in_json_object(doc, schema_ref, field, version) {
	version == "3.0"
	r := split(schema_ref, "/")
	count(r) == 4
	check_content(r[3], field, doc.components.schemas)
} else {
	version == "2.0"
	r := split(schema_ref, "/")
	count(r) == 3
	check_content(r[2], field, doc.definitions)
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

check_reference_unexisting_swagger(doc, reference, type) = checkRef {
	refString := sprintf("#/%s/", [type])
	startswith(reference, refString)
	checkRef := trim_prefix(reference, refString)
	object.get(doc[type], checkRef, "undefined") == "undefined"
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
	type == numeric[_]
}

# It verifies if the string schema does not have the 'field' defined
undefined_field_in_string_type(value, field) {
	value.type == "string"
	object.get(value, field, "undefined") == "undefined"
}

# It verifies if the numeric schema does not have the 'field' defined
undefined_field_in_numeric_schema(value, field) {
	is_numeric_type(value.type)
	object.get(value, field, "undefined") == "undefined"
}

is_path_template(path) = matches {
	matches := regex.find_n(`\{([A-Za-z]+[A-Za-z-_]*[A-Za-z]+)\}`, path, -1)
}

# It verifies if the 'field' is consistent with the 'type'
invalid_field(field, type) {
	is_numeric_type(type)
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

shared := {
	"info": {"value": {"title", "version"}, "array": false, "map_object": false},
	"license": {"value": {"name"}, "array": false, "map_object": false},
	"op": {"value": {"responses"}, "array": false, "map_object": false},
	"externalDocs": {"value": {"url"}, "array": false, "map_object": false},
	"parameters": {"value": {"name", "in"}, "array": true, "map_object": true},
	"responses": {"value": {"description"}, "array": false, "map_object": true},
	"tags": {"value": {"name"}, "array": true, "map_object": false},
}

require_objects_v3 := {
	"info": shared.info,
	"license": shared.license,
	"servers": {"value": {"url"}, "array": true, "map_object": false},
	"server": {"value": {"url"}, "array": false, "map_object": false},
	"variables": {"value": {"default"}, "array": false, "map_object": true},
	"get": shared.op,
	"put": shared.op,
	"post": shared.op,
	"delete": shared.op,
	"options": shared.op,
	"head": shared.op,
	"patch": shared.op,
	"trace": shared.op,
	"externalDocs": shared.externalDocs,
	"parameters": shared.parameters,
	"requestBody": {"value": {"content"}, "array": false, "map_object": false},
	"requestBodies": {"value": {"content"}, "array": false, "map_object": true},
	"responses": shared.responses,
	"headers": {"value": {"name"}, "array": false, "map_object": true},
	"discriminator": {"value": {"propertyName"}, "array": false, "map_object": false},
	"securitySchemes": {"value": {"type"}, "array": false, "map_object": true},
	"implicit": {"value": {"scopes"}, "array": false, "map_object": false},
	"password": {"value": {"scopes"}, "array": false, "map_object": false},
	"clientCredentials": {"value": {"scopes"}, "array": false, "map_object": false},
	"authorizationCode": {"value": {"scopes"}, "array": false, "map_object": false},
	"tags": shared.tags,
}

require_objects_v2 := {
	"info": shared.info,
	"license": shared.license,
	"get": shared.op,
	"put": shared.op,
	"post": shared.op,
	"delete": shared.op,
	"options": shared.op,
	"head": shared.op,
	"patch": shared.op,
	"trace": shared.op,
	"externalDocs": shared.externalDocs,
	"parameters": shared.parameters,
	"items": {"value": {"type"}, "array": false, "map_object": true},
	"responses": shared.responses,
	"headers": {"value": {"type"}, "array": false, "map_object": true},
	"tags": shared.tags,
	"securityDefinitions": {"value": {"type", "name", "in", "flow", "authorizationUrl", "tokenUrl", "scopes"}, "array": false, "map_object": true},
}

# get schema info (object and path) according to the openAPI version
get_schema_info(doc, version) = schemaInfo {
	version == "3.0"
	schemaInfo := {"obj": doc.components.schemas, "path": "components.schemas"}
} else = schemaInfo {
	version == "2.0"
	schemaInfo := {"obj": doc.definitions, "path": "definitions"}
}

api_key_exposed(doc, version, s) {
	version == "3.0"
	doc.components.securitySchemes[s].type == "apiKey"
	server := doc.servers[_]
	startswith(server.url, "http://")
} else {
	version == "3.0"
	doc.components.securitySchemes[s].type == "apiKey"
	not valid_key(doc, "servers")
} else {
	version == "2.0"
	doc.securityDefinitions[s].type == "apiKey"
	scheme := doc.schemes[_]
    scheme == "http"
} else {
	version == "2.0"
	doc.securityDefinitions[s].type == "apiKey"
	not valid_key(doc, "schemes")
}

check_scheme(doc, schemeKey, scope, version) {
	version == "3.0"
	secScheme := doc.components.securitySchemes[schemeKey]
	secScheme.type == "oauth2"

	arr := [x | _ := secScheme.flows[flowKey].scopes[scopeName]; scopeName == scope; x := scope]

	count(arr) == 0
} else {
	version == "2.0"
	secScheme := doc.securityDefinitions[schemeKey]
	secScheme.type == "oauth2"

	arr := [x | _ := secScheme.scopes[scopeName]; scopeName == scope; x := scope]

	count(arr) == 0
}

# It verifies if the path is empty. If so, it refers to a global object. If not, joins it with the defaultValue.
concat_default_value(path, defaultValue) = searchKey {
	count(path) == 0
	searchKey := defaultValue
} else = searchKey {
	searchKey := concat(".", [path, defaultValue])
}

get_name(p, name) = sk {
	p[minus(count(p), 1)] == "components"
	sk := name
} else = sk {
	sk := concat("", ["name=", name])
}

get_complete_search_key(n, parcialSk, property) = sk {
	is_string(n)
	sk := sprintf("%s.%s.%s", [parcialSk, n, property])
} else = sk {
	sk := sprintf("%s.%s", [parcialSk, property])
}

is_mimetype_valid(content) {
	known_prefixs := {"application", "audio", "font", "example", "image", "message", "model", "multipart", "text", "video"}
	count({x | prefix := known_prefixs[x]; startswith(content, prefix)}) > 0
}

get_discriminator(schema, version) = discriminator {
	version == "3.0"
	discriminator := {"obj": schema.discriminator.propertyName, "path": "discriminator.propertyName"}
} else = discriminator {
	version == "2.0"
	discriminator := {"obj": schema.discriminator, "path": "discriminator"}
}

check_definitions(doc, object, name) {
	[path, value] := walk(doc)
	ref := value["$ref"]
	count({x | ref == sprintf("#/%s/%s", [object, name]); x := ref}) == 0
}

is_valid_mime(mime) {
	type := "[A-Za-z0-9][A-Za-z0-9!#$&\\-^_]{0,126}"
	subtype := "[A-Za-z0-9][A-Za-z0-9!#$&\\-^_.+]{0,126}"
	token := "([!#$%&'*+.^_`|~0-9A-Za-z-]+)"
	space := "[ \t]*"
	quotedString := "\"(?:[^\"\\\\]|\\.)*\""
	parameter := concat("", [";", space, token, space, "=", space, "(", token, "|", quotedString, ")"])

	mimeRegex := concat("", ["^", type, "/", "(", subtype, ")", "(", parameter, ")*", "$"])

	regex.match(mimeRegex, mime) == true
}

valid_key(obj, key) {
	_ = obj[key]
	not is_null(obj[key])
}

is_missing_attribute_and_ref(obj, attr) {
	not valid_key(obj, attr)
	not valid_key(obj, "$ref")
}
