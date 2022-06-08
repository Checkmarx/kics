package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i]
	res_type := doc.resource[type]
	res_type[name]
	not is_snake_case(name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": type,
		"resourceName": tf_lib.get_resource_name(res_type, name),
		"searchKey": sprintf("resource.%s.%s", [type, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "All names should be on snake case pattern",
		"keyActualValue": sprintf("'%s' is not in snake case", [name]),
		"searchLine": common_lib.build_search_line(["resource", type, name], []),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	module := doc.module[name]
	not is_snake_case(name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "All names should be on snake case pattern",
		"keyActualValue": sprintf("'%s' is not in snake case", [name]),
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}

is_snake_case(path) {
	re_match(`^([a-z][a-z0-9]*)(_[a-z0-9]+)*$`, path)
}
