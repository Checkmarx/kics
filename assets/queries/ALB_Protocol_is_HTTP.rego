package Cx

SupportedResources = "$.resource ? (@.aws_alb_listener != null || @.aws_lb_listener != null)"

CxPolicy [ result ] {
    lb := {"aws_alb_listener", "aws_lb_listener"}
    resource := input.document[i].resource[lb[idx]][name]

	upper(resource.protocol) = "HTTP"
    not resource.default_action.redirect.protocol

    result := {
                "foundKye": 		resource,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	concat("+", [lb[idx], name]),
                "issueType":		"MissingAttribute",
                "keyName":			"protocol",
                "keyExpectedValue": 8,
                "keyActualValue": 	null,
                #{metadata}
              }
}

CxPolicy [ result ] {
    lb := {"aws_alb_listener", "aws_lb_listener"}
    resource := input.document[i].resource[lb[idx]][name]

    upper(resource.protocol) = "HTTP"
    upper(resource.default_action.redirect.protocol) != "HTTPS"

    result := {
                "foundKye" : 		resource,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	[concat("+", [lb[idx], name]), "default_action", "redirect", "protocol"],
                "issueType":		"IncorrectValue",
                "keyName":			"protocol",
                "keyExpectedValue": "HTTPS",
                "keyActualValue": 	resource.default_action.redirect.protocol,
                #{metadata}
              }
}