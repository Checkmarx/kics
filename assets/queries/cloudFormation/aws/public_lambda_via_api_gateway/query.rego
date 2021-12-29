package Cx

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::Lambda::Permission"
	properties := resource.Properties

	lambdaAction(properties.Action)
	principalAllowAPIGateway(properties.Principal)
	re_match("/\\*/\\*$", properties.SourceArn)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.SourceArn", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SourceArn should not be equal to '/*/*'", [name]),
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
