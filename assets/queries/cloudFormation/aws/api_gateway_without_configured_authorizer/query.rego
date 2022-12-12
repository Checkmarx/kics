package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

types := {"AWS::ApiGateway::RestApi": "AWS::ApiGateway::Authorizer", "AWS::ApiGatewayV2::Api": "AWS::ApiGatewayV2::Authorizer"}

CxPolicy[result] {
	resource := input.document[i].Resources[name]

	field := types[type]
	resource.Type == type

	not has_authorizer_associated(name, field)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "API Gateway REST API should be associated with an API Gateway Authorizer",
		"keyActualValue": "API Gateway REST API is not associated with an API Gateway Authorizer",
		"searchLine": common_lib.build_search_line(["Resources", name], []),
	}
}

has_authorizer_associated(apiName, type) {
	type == "AWS::ApiGatewayV2::Authorizer"
	count({x | resource := input.document[_].Resources[x]; resource.Type == "AWS::ApiGatewayV2::Authorizer"; get_value(resource.Properties,"ApiId") == apiName}) != 0
} else {
	type == "AWS::ApiGateway::Authorizer"
	count({x | resource := input.document[_].Resources[x]; resource.Type == "AWS::ApiGateway::Authorizer"; get_value(resource.Properties,"RestApiId") == apiName}) != 0
}

get_value(properties, field) = value {
	value = properties[field].Ref
} else = value {
	value = properties[field]
}
