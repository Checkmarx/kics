package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	doc := input.document[i]
	res := doc.Resources[stage]
	properties := res.Properties
	res.Type == "AWS::ApiGatewayV2::Stage"

	not properties.AccessLogSettings

	result := {
		"documentId": doc.id,
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'AccessLogSettings' should be defined",
		"keyActualValue": "'AccessLogSettings' is not defined",
		"resourceType": res.Type,
		"resourceName": cf_lib.get_resource_name(res, stage),
		"searchKey": sprintf("Resources.%s.Properties", [stage]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	res := doc.Resources[stage]
	properties := res.Properties
	res.Type == "AWS::ApiGateway::Stage"

	not properties.AccessLogSetting

	result := {
		"documentId": doc.id,
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'AccessLogSetting' should be defined",
		"keyActualValue": "'AccessLogSetting' is not defined",
		"resourceType": res.Type,
		"resourceName": cf_lib.get_resource_name(res, stage),
		"searchKey": sprintf("Resources.%s.Properties", [stage]),
	}
}
