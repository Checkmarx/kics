package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	req := openapi_lib.require_objects[obj_type]
	obj := value[obj_type]
	req_obj := check_required(obj, req)
	search_key := create_search_key(req_obj, path, obj_type)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s", [search_key[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s has all required feilds", [obj_type]),
		"keyActualValue": sprintf("%s is missing required feilds", [obj_type]),
	}
}

check_required(obj, req) = req_obj {
	req.array = true
	req.map_object = false
	set := {x | item := obj[n]; object.get(item, req.value[val], "undefined") == "undefined"; x := item}
	count(set) > 0
	req_obj := ""
} else = req_obj {
	req.map_object = true
	set := {x | item := obj[n]; object.get(item, req.value[val], "undefined") == "undefined"; x := n}
	count(set) > 0
	req_obj := set
} else = req_obj {
	req.array = false
	req.map_object = false
	set := {x | object.get(obj, req.value[val], "undefined") == "undefined"; x := obj}
	count(set) > 0
	req_obj := ""
}

create_search_key(req_obj, path, obj_type) = searchKey {
	is_set(req_obj)
	is_string(req_obj[m])
	searchKey := {x | key := req_obj[n]; x := sprintf("%s.%s.%s", [openapi_lib.concat_path(path), obj_type, key])}
} else = searchKey {
	count(path) == 0
	searchKey := {x | x := sprintf("%s", [obj_type])}
} else = searchKey {
	not is_number(req_obj)
	req_obj != ""
	searchKey := {x | x := sprintf("%s.%s.%s", [openapi_lib.concat_path(path), obj_type, req_obj])}
} else = searchKey {
	searchKey := {x | x := sprintf("%s.%s", [openapi_lib.concat_path(path), obj_type])}
}
