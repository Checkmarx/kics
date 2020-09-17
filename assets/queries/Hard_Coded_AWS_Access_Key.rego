package Cx

SupportedResources = "$.resource.aws_instance"

CxPolicy [ result ] {
    ud := input.document[i].resource.aws_instance[name].user_data
    re_match("([^A-Z0-9])[A-Z0-9]{20}([^A-Z0-9])", ud)

    result := {
                "foundKye": 		ud,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	[concat("+", ["aws_instance", name]), "user_data"],
                "issueType":		"IncorrectValue",
                "keyName":			"user_data",
                "keyExpectedValue": null,
                "keyActualValue": 	ud,
                #{metadata}
              }
}

CxPolicy [ result ] {
    ud := input.document[i].resource.aws_instance[name].user_data
    re_match("[A-Za-z0-9/+=]{40}([^A-Za-z0-9/+=])", ud)

    result := {
                "foundKye": 		ud,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	[concat("+", ["aws_instance", name]), "user_data"],
                "issueType":		"IncorrectValue",
                "keyName":			"user_data",
                "keyExpectedValue": null,
                "keyActualValue": 	ud,
                #{metadata}
              }
}


