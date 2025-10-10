package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	operation := doc.paths[path][op]
	response := operation.responses[code]
	acceptable_response(code, op)
	
	results := get_results(response, path, op, code, version, doc)[_]

	result := {
		"documentId": doc.id,
		"searchKey": results.searchKey,
		"issueType": "MissingAttribute",
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine,
		"overrideKey": results.overrideKey,
	}
}

get_results(response, path, op, code, version, doc) = output {
	key := get_key_by_version(version)
	not common_lib.valid_key(response, key)
	not has_valid_ref(response, doc, version)

	output := [{
		"searchKey": sprintf("paths.%s.%s.responses.%s", [path, op, code]),
		"keyExpectedValue": sprintf("paths.%s.%s.responses.%s.%s should be defined", [path, op, code, key]),
		"keyActualValue": sprintf("paths.%s.%s.responses.%s.%s is undefined", [path, op, code, key]),
		"searchLine": common_lib.build_search_line(["paths", path, op, "responses", code], []),
		"overrideKey": version,
	}]

} else = output {
	version == "3.0"
	count(response.content) == 0

	output := [{
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content", [path, op, code]),
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content should have at least one content-type defined", [path, op, code]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content has no content-type defined", [path, op, code]),
		"searchLine": common_lib.build_search_line(["paths", path, op, "responses", code, "content"], []),
		"overrideKey": "3.0",
	}]
} else = output {
	version == "3.0"

	output := [{
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}", [path, op, code, content_type]),
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema should be defined", [path, op, code, content_type]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema is undefined", [path, op, code, content_type]),
		"searchLine": common_lib.build_search_line(["paths", path, op, "responses", code, "content", content_type], []),
		"overrideKey": "3.0",
	} | some content_type
		responses := response.content[content_type]
		not common_lib.valid_key(responses, "schema")
	]
}

acceptable_response(code, op) {
	operation_should_have_content := ["get", "put", "post", "delete", "options", "patch", "trace"]
	common_lib.equalsOrInArray(operation_should_have_content, lower(op))

	response_code_should_not_have_content := ["204", "304"]

	not common_lib.equalsOrInArray(response_code_should_not_have_content, lower(code))
}

get_key_by_version(version) = key {
	keys := {
		"2.0": "schema",
		"3.0": "content",
	}

	key = keys[version]
}

has_valid_ref(obj, doc, version) {
	version == "3.0"
	ref := get_ref(obj)
	
	path := split(substring(ref, 2, -1), "/")		
	type := path[minus(count(path), 2)]
	resource := doc.components[type][path[minus(count(path), 1)]]

	is_schema_or_has_schema(resource, type)
} else {
	version == "2.0"
	ref := get_ref(obj)

	path := split(substring(ref, 2, -1), "/")
	type := path[minus(count(path), 2)]
	resource := doc[type][path[minus(count(path), 1)]]

	is_schema_or_has_schema(resource, type)
} 

get_ref(obj) = res{
	res := obj["RefMetadata"]["$ref"]		# --enable-openapi-refs 
	res != null
} else = res {
	res := obj["$ref"]
	res != null
}

is_schema_or_has_schema(resource, type) {
	type == ["schemas","definitions"][_]	
	resource != null					
} else {
	common_lib.valid_key(resource, "schema")	# swagger 2.0
} else {
	common_lib.valid_key(resource[_][_], "schema")	# 3.0
}