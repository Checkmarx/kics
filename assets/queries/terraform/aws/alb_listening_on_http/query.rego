package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

lb := {"aws_alb_listener", "aws_lb_listener"}

CxPolicy[result] {
	resource := input.document[i].resource[lb[idx]][name]

	check_application(resource)
	is_http(resource)

	not common_lib.valid_key(resource.default_action, "redirect")

	result := {
		"documentId": input.document[i].id,
		"resourceType": lb[idx],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].default_action", [lb[idx], name]),
		"searchLine": common_lib.build_search_line(["resource", lb[idx], name, "default_action"], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'default_action.redirect.protocol' should be equal to 'HTTPS'",
		"keyActualValue": "'default_action.redirect' is missing",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[lb[idx]][name]

	check_application(resource)
	is_http(resource)

	not common_lib.valid_key(resource.default_action.redirect, "protocol")

	result := {
		"documentId": input.document[i].id,
		"resourceType": lb[idx],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].default_action.redirect", [lb[idx], name]),
		"searchLine": common_lib.build_search_line(["resource", lb[idx], name, "default_action", "redirect"], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'default_action.redirect.protocol' should be equal to 'HTTPS'",
		"keyActualValue": "'default_action.redirect.protocol' is missing",
		"remediation": "protocol = \"HTTPS\"",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[lb[idx]][name]

	check_application(resource)
	is_http(resource)

	upper(resource.default_action.redirect.protocol) != "HTTPS"

	result := {
		"documentId": input.document[i].id,
		"resourceType": lb[idx],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].default_action.redirect.protocol", [lb[idx], name]),
		"searchLine": common_lib.build_search_line(["resource", lb[idx], name, "default_action", "redirect", "protocol"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'default_action.redirect.protocol' should be equal to 'HTTPS'",
		"keyActualValue": sprintf("'default_action.redirect.protocol' is equal '%s'", [resource.default_action.redirect.protocol]),
		"remediation": json.marshal({
			"before": sprintf("%s", [resource.default_action.redirect.protocol]),
			"after": "HTTPS"
		}),
		"remediationType": "replacement",
	}
}

is_http(resource) {
	upper(resource.protocol) == "HTTP"
}

is_http(resource) {
	not common_lib.valid_key(resource, "protocol")
}

is_application(resource) {
	resource.load_balancer_type == "application"
}

is_application(resource) {
	not common_lib.valid_key(resource, "load_balancer_type")
}

check_application(resource) {
	lbs := {"aws_alb", "aws_lb"}
	lb_info := split(resource.load_balancer_arn, ".")
	lb_name = lb_info[1]
	lb := input.document[_].resource[lbs[idx]][name]
	lb_name == name
	is_application(lb)
}
