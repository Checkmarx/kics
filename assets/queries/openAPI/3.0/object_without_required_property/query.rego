package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)
	req := openapi_lib.require_objects_v3[obj_type]
	obj := value[obj_type]
	req_obj := check_required(obj, req)
	search_key := create_search_key(req_obj, path, obj_type)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s", [search_key[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s has all required fields", [obj_type]),
		"keyActualValue": sprintf("%s is missing required fields", [obj_type]),
	}
}

check_required(obj, req) = req_obj {
	req.array = true
	req.map_object = false
	set := {x | item := obj[n]; not common_lib.valid_key(item, "$ref"); v := req.value[val]; not common_lib.valid_key(item, v); x := item}
	count(set) > 0
	req_obj := ""
} else = req_obj {
	req.map_object = true
	set := {x | item := obj[n]; not common_lib.valid_key(item, "$ref"); v := req.value[val]; not common_lib.valid_key(item, v); x := n}
	count(set) > 0
	req_obj := set
} else = req_obj {
	req.array = false
	req.map_object = false
	set := {x | not common_lib.valid_key(obj, "$ref"); v := req.value[val]; not common_lib.valid_key(obj, v); x := obj}
	count(set) > 0
	req_obj := ""
}

create_search_key(req_obj, path, obj_type) = searchKey {
	count(path) > 0
	is_set(req_obj)
	is_string(req_obj[m])
	searchKey := {x | key := req_obj[n]; x := sprintf("%s.%s.%s", [openapi_lib.concat_path(path), obj_type, key])}
} else = searchKey {
	count(path) == 0
	is_set(req_obj)
	searchKey := {x | x := sprintf("%s.%s", [obj_type, req_obj[o]])}
} else = searchKey {
	count(path) == 0
	is_string(req_obj)
	searchKey := {x | x := sprintf("%s.%s", [obj_type, req_obj])}
} else = searchKey {
	not is_number(req_obj)
	req_obj != ""
	searchKey := {x | x := sprintf("%s.%s.%s", [openapi_lib.concat_path(path), obj_type, req_obj])}
} else = searchKey {
	searchKey := {x | x := sprintf("%s.%s", [openapi_lib.concat_path(path), obj_type])}
}
