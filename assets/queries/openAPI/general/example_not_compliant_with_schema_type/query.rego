package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

# policy for examples
CxPolicy[result] {
	docs := input.document[i]
	version := openapi_lib.check_openapi(docs)
	version == "3.0"

	[path, value] = walk(docs)
	path[n] != "components"

	ex_obj := get_ref(value.examples[name], docs, "examples", version)
	schema_obj := get_ref(value.schema, docs, "schemas", version)
	properties := get_properties(schema_obj)
	items := compare_prop(ex_obj.value, properties)
	count(items) > 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.examples.%s", [openapi_lib.concat_path(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.examples.%s' should not be compliant with the schema type", [concat(".", path)]),
		"keyActualValue": sprintf("%s.examples.%s is not compliant with the schema type", [concat(".", path)]),
		"overrideKey": version,
	}
}

# policy for example
CxPolicy[result] {
	docs := input.document[i]
	version := openapi_lib.check_openapi(docs)
	version == "3.0"

	[path, value] = walk(docs)
	path[n] != "components"

	schema_obj := get_ref(value.schema, docs, "schemas", version)
	properties := get_properties(schema_obj)
	items := compare_prop(value.example, properties)
	count(items) > 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.example", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.example should not be compliant with the schema type", [concat(".", path)]),
		"keyActualValue": sprintf("%s.example is not compliant with the schema type", [concat(".", path)]),
		"overrideKey": version,
	}
}

# policy for example
CxPolicy[result] {
	docs := input.document[i]
	version := openapi_lib.check_openapi(docs)
	version == "2.0"

	[path, value] = walk(docs)
	path[n] != "definitions"

	schema_obj := get_ref(value.schema, docs, "definitions", version)
	properties := get_properties(schema_obj)
	items := compare_prop(schema_obj.example, properties)
	count(items) > 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.example", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.example should not be compliant with the schema type", [openapi_lib.concat_path(path)]),
		"keyActualValue": sprintf("%s.example is not compliant with the schema type", [openapi_lib.concat_path(path)]),
		"overrideKey": version,
	}
}

CxPolicy[result] {
	docs := input.document[i]
	version := openapi_lib.check_openapi(docs)
	version == "2.0"

	schema_obj := get_ref(docs.definitions[name], docs, "definitions", version)
	properties := get_properties(schema_obj)
	items := compare_prop(schema_obj.example, properties)
	count(items) > 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("definitions.%s.example", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("definitions.%s.example should not be compliant with the schema type", [name]),
		"keyActualValue": sprintf("definitions.%s.example is not compliant with the schema type", [name]),
		"overrideKey": version,
	}
}

# compare_prop() - checks if the example is compliant with schema type, returns a set with all fields that are not valid
compare_prop(ex_obj, prop) = items {
	prop.object == true
	items := {x | prop_item := prop.properties[n]; not check_prop(prop_item, ex_obj, n); x := {"name": n}}
} else = items {
	prop.array == true
	items := {x | prop_item := ex_obj[z]; not check_type(prop.item_type, type_name(prop_item)); x := {"name": ex_obj[z]}}
} else = items {
	items := {x | not check_type(prop.type, type_name(ex_obj)); x := {"name": ex_obj}}
}

# check_prop() - checks if all object properties are present in the example and if they have the correct type
check_prop(prop, ex_obj, name) {
	common_lib.valid_key(ex_obj, name)
	check_type(prop.type, type_name(ex_obj[name]))
}

check_type(type, exampleType) {
	exampleType == "number"
	check_number_type(type)
} else {
	exampleType == type
}

check_number_type(type) {
	type == "number"
} else {
	type == "integer"
}

# get_ref() - returns the object based on the type (schema, examples). If the object is a ref gets the object from the ref
get_ref(obj, docs, type, version) = example {
	not common_lib.valid_key(obj, "$ref")
	example := obj
} else = example {
	version == "3.0"
	path := split(substring(obj["$ref"], 2, -1), "/")
	example := docs.components[type][path[minus(count(path), 1)]]
} else = example {
	version == "2.0"
	path := split(substring(obj["$ref"], 2, -1), "/")
	example := docs[type][path[minus(count(path), 1)]]
}

# get_properties() - returns properties, type, and fields to compare
get_properties(schema) = properties {
	schema.type == "object"
	properties := {"object": true, "type": schema.type, "properties": schema.properties}
} else = properties {
	schema.type == "array"
	properties := {"array": true, "type": schema.type, "item_type": schema.items.type}
} else = properties {
	properties := {"type": schema.type}
}
