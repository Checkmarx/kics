package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	arr := check_property(doc)
	count(arr[name]) > 1

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.properties.%s", [openapi_lib.concat_path(arr[name][_].path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' property is unique throughout the whole API", [name]),
		"keyActualValue": sprintf("'%s' property is not unique throughout the whole API", [name]),
	}
}

# check_property will create an array with all the name fields of the properties
# in the API specification and for each name create an array with the objects that contain that name
# so we can later look for dups using the count function
check_property(doc) = arr {
	propName := [x | [path, value] := walk(doc); value.properties[name]; x := {"name": name, "path": path}]
	arr := {id: objCount |
		id := propName[i].name
		objCount := [obj |
			propName[j].name == id
			obj := propName[j]
		]
	}
}
