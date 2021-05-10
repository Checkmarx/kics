package Cx

lb := {"aws_alb_listener", "aws_lb_listener"}

CxPolicy[result] {
	resource := input.document[i].resource[lb[idx]][name]

	upper(resource.protocol) == "HTTP"
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

	upper(resource.protocol) == "HTTP"
	upper(resource.default_action.redirect.protocol) != "HTTPS"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].default_action.redirect.protocol", [lb[idx], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'default_action.redirect.protocol' is equal to 'HTTPS'",
		"keyActualValue": sprintf("'default_action.redirect.protocol' is equal '%s'", [resource.default_action.redirect.protocol]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_lb_target_group[name]
	upper(resource.protocol) == "HTTP"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_lb_target_group[%s].protocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_lb_target_group.protocol' is equal to 'HTTPS'",
		"keyActualValue": sprintf("'aws_lb_target_group.protocol' is equal '%s'", [resource.protocol]),
	}
}
