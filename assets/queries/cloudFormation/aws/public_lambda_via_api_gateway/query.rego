package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some docs in input.document
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Lambda::Permission"
	properties := resource.Properties

	lambdaAction(properties.Action)
	principalAllowAPIGateway(properties.Principal)
	re_match("/\\*/\\*$", properties.SourceArn)

	result := {
		"documentId": docs.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.SourceArn", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SourceArn should not equal to '/*/*'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.SourceArn is equal to '/*/*' or contains '/*/*'", [name]),
	}
}

lambdaAction("lambda:*") = true

lambdaAction("lambda:InvokeFunction") = true

principalAllowAPIGateway("*") = true

principalAllowAPIGateway("apigateway.amazonaws.com") = true
