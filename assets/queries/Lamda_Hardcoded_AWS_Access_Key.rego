package Cx

SupportedResources = "$.resource.aws_lambda_function"

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_lambda_function[name]
    vars = input.document[i].resource.aws_lambda_function[name].environment.variables
    re_match("[A-Za-z0-9/+=]{40}", vars[_])

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_lambda_function[%s].environment.variables", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": null,
                "keyActualValue": 	null
              })
}

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_lambda_function[name]
    vars = resource.environment.variables
    re_match("[A-Z0-9]{20}", vars[_])

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_lambda_function[%s].environment.variables", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": null,
                "keyActualValue": 	null
              })
}
