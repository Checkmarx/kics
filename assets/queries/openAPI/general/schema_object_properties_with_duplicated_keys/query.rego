package Cx

import data.generic.openapi as openapi_lib

# components schemas map
CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version == "3.0"

	schemas := doc.components.schemas[name]

	porperties := get_properties(schemas)
	val := porperties[m].value
	check_properties(val, porperties, m)
	search_key := create_searchkey(name, porperties[m].path, val)

	result := {
		"documentId": doc.id,
		"searchKey": search_key,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' is unique through out the fields 'properties', 'allOf' and 'additionalProperties'", [val]),
		"keyActualValue": sprintf("'%s' is not unique through out the fields 'properties', 'allOf' and 'additionalProperties'", [val]),
	}
}

# schema object
CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)

	porperties := get_properties(value.schema)
	val := porperties[m].value
	check_properties(val, porperties, m)
	search_key := create_searchkey(path, porperties[m].path, val)

	result := {
		"documentId": doc.id,
		"searchKey": search_key,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' is unique through out the fields 'properties', 'allOf' and 'additionalProperties'", [val]),
		"keyActualValue": sprintf("'%s' is not unique through out the fields 'properties', 'allOf' and 'additionalProperties'", [val]),
		"overrideKey": version,
	}
}

create_searchkey(name, path, val) = search_key {
	is_array(name)
	count(path) != 0
	search_key := sprintf("%s.%s.%s", [openapi_lib.concat_path(name), openapi_lib.concat_path(path), val])
} else = search_key {
	is_array(name)
	count(path) == 0
	search_key := sprintf("%s.%s", [openapi_lib.concat_path(name), val])
} else = search_key {
	count(path) == 0
	search_key := sprintf("components.schemas.%s.%s", [name, val])
} else = search_key {
	search_key := sprintf("components.schemas.%s.%s.%s", [name, openapi_lib.concat_path(path), val])
}

check_properties(value, properties, m) {
	set := {x |
		tt := properties[z].value
		z != m
		tt == value
		x := value
	}

	count(set) > 0
}

get_properties(schema) = properties {
	properties := {x |
		[path, value] := walk(schema)
		prop := value.properties
		filter_paths(path)
		prop[name]
		x := {"path": path, "value": name}
	}
}

filter_paths(path) {
	count(path) == 0
} else {
	any([contains(path[_], "allOf"), contains(path[_], "additionalProperties")])
}
