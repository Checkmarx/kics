package Cx

CxPolicy[result] {
	resource := input.document[i].resource[name]
	types := {"aws_alb", "aws_lb"}
	name == types[x]
	res := resource[m]
	check_load_balancer_type(res)
	res.drop_invalid_header_fields == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[{{%s}}].drop_invalid_header_fields", [types[x], m]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[{{%s}}].drop_invalid_header_fields is set to true", [types[x], m]),
		"keyActualValue": sprintf("%s[{{%s}}].drop_invalid_header_fields is set to false", [types[x], m]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[name]
	types := {"aws_alb", "aws_lb"}
	name == types[x]
	res := resource[m]
	check_load_balancer_type(res)
	object.get(res, "drop_invalid_header_fields", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[{{%s}}]", [types[x], m]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[{{%s}}].drop_invalid_header_fields is set to true", [types[x], m]),
		"keyActualValue": sprintf("%s[{{%s}}].drop_invalid_header_fields is missing", [types[x], m]),
	}
}

check_load_balancer_type(res) {
	res.load_balancer_type == "application"
} else {
	object.get(res, "load_balancer_type", "undefined") == "undefined"
} else = false {
	true
}
