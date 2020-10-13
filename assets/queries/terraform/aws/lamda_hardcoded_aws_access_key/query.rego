package Cx

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_lambda_function[name]
    vars = resource.environment.variables
    re_match("[A-Za-z0-9/+=]{40}", vars[var])

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_lambda_function[%s].environment.variables", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'environment.variables' doesn't contain access key",
                "keyActualValue": 	"'environment.variables' contains access key"
              })
}

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_lambda_function[name]
    vars = resource.environment.variables
    re_match("[A-Z0-9]{20}", vars[var])

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_lambda_function[%s].environment.variables", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'environment.variables' doesn't contain access key",
                "keyActualValue": 	"'environment.variables' contains access key"
              })
}
