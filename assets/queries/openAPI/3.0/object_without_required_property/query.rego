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
	searches := create_searches(req_obj, path, obj_type)

	result := {
		"documentId": doc.id,
		"searchKey": searches[m].sk,
		"searchLine": searches[m].sl,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s has all required fields", [obj_type]),
		"keyActualValue": sprintf("%s is missing required fields", [obj_type]),
	}
}

check_required(obj, req) = req_obj {
	req.array = true
	req.map_object = false
	set := {item |
		item := obj[_]
		not common_lib.valid_key(item, "$ref")
		v := req.value[_]
		not common_lib.valid_key(item, v)
	}
	count(set) > 0
	req_obj := ""
} else = req_obj {
	req.map_object = true
	set := {n |
		item := obj[n]
		not common_lib.valid_key(item, "$ref")
		v := req.value[_]
		not common_lib.valid_key(item, v)
	}
	count(set) > 0
	req_obj := set
} else = req_obj {
	req.array = false
	req.map_object = false
	set := {obj |
		not common_lib.valid_key(obj, "$ref")
		v := req.value[_]
		not common_lib.valid_key(obj, v)
	}
	count(set) > 0
	req_obj := ""
}

create_searches(req_obj, path, obj_type) = searches {
	count(path) > 0
	is_set(req_obj)
	searches := {{
		"sk": sprintf("%s.%s.%s", [openapi_lib.concat_path(path), obj_type, key]),
		"sl": common_lib.build_search_line(path, [obj_type, key]),
	} | key := req_obj[_]; is_string(key)} | {{
		"sk": sprintf("%s.%s", [openapi_lib.concat_path(path), obj_type]),
		"sl": common_lib.build_search_line(path, [obj_type, key]),
	} | key := req_obj[_]; is_number(key)}
} else = searches {
	count(path) == 0
	is_set(req_obj)
	searches := {{
		"sk": sprintf("%s.%s", [obj_type, x]),
		"sl": common_lib.build_search_line([obj_type, x], []),
	} | x := req_obj[_]}
} else = searches {
	count(path) == 0
	is_string(req_obj)
	searches := {{
		"sk": obj_type,
		"sl": common_lib.build_search_line([obj_type], []),
	}}
} else = searchKey {
	searchKey := {{
		"sk": sprintf("%s.%s", [openapi_lib.concat_path(path), obj_type]),
		"sl": common_lib.build_search_line(path, [obj_type])
	}}
}
