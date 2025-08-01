package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::Serverless::Api"
	properties := resource.Properties
	not common_lib.valid_key(properties, "CacheClusterEnabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.CacheClusterEnabled should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.CacheClusterEnabled is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::Serverless::Api"
	properties := resource.Properties

	cf_lib.isCloudFormationFalse(properties.CacheClusterEnabled)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.CacheClusterEnabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.CacheClusterEnabled should be set to true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.CacheClusterEnabled is set to false", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "CacheClusterEnabled"], []),
	}
}
