package Cx

import data.generic.openapi as openapi_lib

# policy for examples
CxPolicy[result] {
	docs := input.document[i]
	openapi_lib.check_openapi(docs) != "undefined"

	[path, value] = walk(docs)
	path[n] != "components"

	ex_obj := get_ref(value.examples[name], docs, "examples")
	schema_obj := get_ref(value.schema, docs, "schemas")
	properties := get_properties(schema_obj)
	items := compare_prop(ex_obj.value, properties)
	count(items) > 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.examples.%s", [openapi_lib.concat_path(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.examples.%s' is not compliant with the schema type", [concat(".", path)]),
		"keyActualValue": sprintf("%s.examples.%s is not compliant with the schema type", [concat(".", path)]),
	}
}

# policy for example
CxPolicy[result] {
	docs := input.document[i]
	openapi_lib.check_openapi(docs) != "undefined"

	[path, value] = walk(docs)
	path[n] != "components"

	schema_obj := get_ref(value.schema, docs, "schemas")
	properties := get_properties(schema_obj)
	items := compare_prop(value.example, properties)
	count(items) > 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.example", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.example is not compliant with the schema type", [concat(".", path)]),
		"keyActualValue": sprintf("%s.example is not compliant with the schema type", [concat(".", path)]),
	}
}

# compare_prop() - checks if the example is complient with schema type, returns a set with all feilds that are not valid
compare_prop(ex_obj, prop) = items {
	prop.object == true
	items := {x | prop_item := prop.properties[n]; not check_prop(prop_item, ex_obj, n); x := {"name": n}}
} else = items {
	prop.array == true
	items := {x | prop_item := ex_obj[z]; get_type(prop_item) != prop.item_type; x := {"name": ex_obj[z]}}
} else = items {
	items := {x | get_type(ex_obj) != prop.type; x := {"name": ex_obj}}
}

# check_prop() - checks if all object properties are present in the example and if they have the correct type
check_prop(prop, ex_obj, name) {
	object.get(ex_obj, name, "undefined") != "undefined"
	get_type(ex_obj[name]) == prop.type
}

# get_type() - get the type of the value present in the example
get_type(obj_feild) = type {
	is_number(obj_feild)
	type := "integer"
} else = type {
	is_string(obj_feild)
	type := "string"
} else = type {
	is_boolean(obj_feild)
	type := "boolean"
}

# get_ref() - returns the object based on the type (schema, examples). If the object is a ref gets the object from the ref
get_ref(obj, docs, type) = example {
	object.get(obj, "$ref", "undefined") == "undefined"
	example := obj
} else = example {
	path := split(substring(obj["$ref"], 2, -1), "/")
	example := docs.components[type][path[minus(count(path), 1)]]
}

# get_properties() - returns properties, type, and feilds to compare
get_properties(schema) = properties {
	schema.type == "object"
	properties := {"object": true, "type": schema.type, "properties": schema.properties}
} else = properties {
	schema.type == "array"
	properties := {"array": true, "type": schema.type, "item_type": schema.items.type}
} else = properties {
	properties := {"type": schema.type}
}
