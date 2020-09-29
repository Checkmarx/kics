package Cx

SupportedResources = "$.resource.aws_instance"

CxPolicy [ result ] {
    ud := input.document[i].resource.aws_instance[name].user_data
    re_match("([^A-Z0-9])[A-Z0-9]{20}([^A-Z0-9])", ud)

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_instance[%s].user_data", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "NOT ACCESS KEY",
                "keyActualValue": 	ud
              })
}

CxPolicy [ result ] {
    ud := input.document[i].resource.aws_instance[name].user_data
    re_match("[A-Za-z0-9/+=]{40}([^A-Za-z0-9/+=])", ud)

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_instance[%s].user_data", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "NOT ACCESS KEY",
                "keyActualValue": 	ud
              })
}


