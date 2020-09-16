package Cx

SupportedResources = "$.resource.aws_lambda_function"

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_lambda_function[name]
    vars = input.document[i].resource.aws_lambda_function[name].environment.variables
    re_match("[A-Za-z0-9/+=]{40}", vars[_])

    result := {
                "foundKye": 		vars,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	[concat("+", ["aws_lambda_function", name]), "variables"],
                "issueType":		"IncorrectValue",
                "keyName":			"environment.variables",
                "keyExpectedValue": null,
                "keyActualValue": 	null,
                #{metadata}
              }
}

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_lambda_function[name]
    vars = resource.environment.variables
    re_match("[A-Z0-9]{20}", vars[_])

    result := {
                "foundKye": 		vars,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	[concat("+", ["aws_lambda_function", name]), "variables"],
                "issueType":		"IncorrectValue",
                "keyName":			"environment.variables",
                "keyExpectedValue": null,
                "keyActualValue": 	null,
                #{metadata}
              }
}
