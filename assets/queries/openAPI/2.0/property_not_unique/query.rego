package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	arr := check_property(doc)
	count(arr[name].count) > 1

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.properties.%s", [openapi_lib.concat_path(arr[name].path), name]),
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
	arr := {id: {"count": objCount, "path": p} |
		id := propName[i].name
		objCount := [obj |
			propName[j].name == id
			obj := propName[j]
		]

		p := create_path(objCount)
	}
}

# create_path will go through the paths in the object and return the smallest path count
create_path(objCount) = path {
	pathLen := [x | len := count(objCount[n].path); x := {"idx": n, "len": len}]
	minPath := [y | k := pathLen[0].len; y := check_len(k, pathLen)]
	path := objCount[minPath[0].idx].path
}

check_len(size, obj) = minimum {
	obj[s].len < size
	minimum := obj[s]
} else = minimum {
	minimum := obj[0]
}
