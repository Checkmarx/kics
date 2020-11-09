package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.aws_lambda_function[name]
    permissionResource := input.file[i].resource.aws_lambda_permission[permissionName]

    contains(permissionResource.function_name, concat(".", ["aws_lambda_function", name]))
    permissionResource.action == "lambda:InvokeFunction"
    principalAllowAPIGateway(permissionResource.principal)
    re_match("/\\*/\\*$", permissionResource.source_arn)

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_lambda_permission[%s].source_arn", [permissionName]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'source_arn' is not equal '/*/*'",
                "keyActualValue": 	"'source_arn' is equal '/*/*'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
                "value":            resource.handler
              }
}

principalAllowAPIGateway(principal) = allow {
	principal == "*"
    allow = true
} else = allow {
	principal == "apigateway.amazonaws.com"
    allow = true
}