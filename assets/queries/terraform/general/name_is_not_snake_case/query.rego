package Cx

CxPolicy[result] {
	doc := input.document[i]
	res_type := doc.resource[type]
	_ := res_type[name]
	not is_snake_case(name)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resource.%s.%s", [type, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "All names should be on snake case pattern",
		"keyActualValue": sprintf("'%s' is not in snake case", [name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	module := doc.module[name]
	not is_snake_case(name)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "All names should be on snake case pattern",
		"keyActualValue": sprintf("'%s' is not in snake case", [name]),
	}
}

is_snake_case(path) {
	re_match(`^([a-z][a-z0-9]*)(_[a-z0-9]+)*$`, path)
}
