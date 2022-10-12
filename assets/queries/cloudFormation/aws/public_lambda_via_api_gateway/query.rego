package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Lambda::Permission"
	properties := resource.Properties

	lambdaAction(properties.Action)
	principalAllowAPIGateway(properties.Principal)
	re_match("/\\*/\\*$", properties.SourceArn)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.SourceArn", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SourceArn should not equal to '/*/*'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.SourceArn is equal to '/*/*' or contains '/*/*'", [name]),
	}
}

lambdaAction(action) {
	action == "lambda:*"
} else {
	action == "lambda:InvokeFunction"
}

principalAllowAPIGateway(principal) {
	principal == "*"
} else {
	principal == "apigateway.amazonaws.com"
}
