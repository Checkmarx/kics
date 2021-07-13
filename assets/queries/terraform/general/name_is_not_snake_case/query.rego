package Cx

CxPolicy[result] {
	doc := input.document[i]
	[path, value] := walk(doc)
	not is_object(value)
	not is_snake_case(path[idx])
	wrongPath := array.slice(path, 0, idx + 1)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s", [concat(".", wrongPath)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "All names should be on snake case pattern",
		"keyActualValue": sprintf("'%s' is not in snake case", [path[idx]]),
	}
}

is_snake_case(path) {
	re_match(`^([a-z][a-z0-9]*)(_[a-z0-9]+)*$`, path)
}
