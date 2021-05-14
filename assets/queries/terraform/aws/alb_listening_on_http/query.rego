package Cx

lb := {"aws_alb_listener", "aws_lb_listener"}

CxPolicy[result] {
	resource := input.document[i].resource[lb[idx]][name]

	check_application(resource)
	is_http(resource)
	not resource.default_action.redirect.protocol

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].default_action.redirect", [lb[idx], name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'default_action.redirect.protocol' is equal to 'HTTPS'",
		"keyActualValue": "'default_action.redirect.protocol' is missing",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[lb[idx]][name]

	check_application(resource)
	is_http(resource)
	upper(resource.default_action.redirect.protocol) != "HTTPS"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].default_action.redirect.protocol", [lb[idx], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'default_action.redirect.protocol' is equal to 'HTTPS'",
		"keyActualValue": sprintf("'default_action.redirect.protocol' is equal '%s'", [resource.default_action.redirect.protocol]),
	}
}

is_http(resource) {
	upper(resource.protocol) == "HTTP"
}

is_http(resource) {
	object.get(resource, "protocol", "undefined") == "undefined"
}

is_application(resource) {
	resource.load_balancer_type == "application"
}

is_application(resource) {
	object.get(resource, "load_balancer_type", "undefined") == "undefined"
}

check_application(resource) {
	lbs := {"aws_alb", "aws_lb"}
	lb_info := split(resource.load_balancer_arn, ".")
	lb_name = lb_info[1]
	lb := input.document[_].resource[lbs[idx]][name]
	lb_name == name
	is_application(lb)
}
