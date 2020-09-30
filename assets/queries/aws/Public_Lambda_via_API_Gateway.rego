package Cx

SupportedResources = "$.resource.aws_lambda_function"
        
CxPolicy [ result ] {
    resource := input.document[i].resource.aws_lambda_function[name]
    permissionResource := input.document[i].resource.aws_lambda_permission[permissionName]

    contains(permissionResource.function_name, concat(".", ["aws_lambda_function", name]))
    permissionResource.action == "lambda:InvokeFunction"
    principalAllowAPIGateway(permissionResource.principal)
    re_match("/\\*/\\*$", permissionResource.source_arn)

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_lambda_permission[%s].source_arn", [permissionName]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "NOT /*/*",
                "keyActualValue": 	permissionResource.source_arn,
                "value":            resource.handler
              })
}

principalAllowAPIGateway(principal) = allow {
	principal == "*"
    allow = true
} else = allow {
	principal == "apigateway.amazonaws.com"
    allow = true
}