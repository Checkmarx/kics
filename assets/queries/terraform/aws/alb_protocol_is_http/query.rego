package Cx

CxPolicy [ result ] {
    lb := {"aws_alb_listener", "aws_lb_listener"}
    resource := input.file[i].resource[lb[idx]][name]

	upper(resource.protocol) = "HTTP"
    not resource.default_action.redirect.protocol

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("%s[%s].default_action.redirect", [lb[idx], name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'default_action.redirect.protocol' is equal 'HTTPS'",
                "keyActualValue": 	"'default_action.redirect.protocol' is missing",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}

CxPolicy [ result ] {
    lb := {"aws_alb_listener", "aws_lb_listener"}
    resource := input.file[i].resource[lb[idx]][name]

    upper(resource.protocol) = "HTTP"
    upper(resource.default_action.redirect.protocol) != "HTTPS"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey":        sprintf("%s[%s].default_action.redirect.protocol", [lb[idx], name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'default_action.redirect.protocol' is equal 'HTTPS'",
                "keyActualValue": 	sprintf("'default_action.redirect.protocol' is equal '%s'", [resource.default_action.redirect.protocol]),
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}