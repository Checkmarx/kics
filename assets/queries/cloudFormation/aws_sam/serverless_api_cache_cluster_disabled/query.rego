package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource = document.Resources[name]
	resource.Type == "AWS::Serverless::Api"
	properties := resource.Properties
	not common_lib.valid_key(properties, "CacheClusterEnabled")

	result := {
		"documentId": document.id,
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
	some document in input.document
	resource = document.Resources[name]
	resource.Type == "AWS::Serverless::Api"
	properties := resource.Properties

	properties.CacheClusterEnabled == false

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.CacheClusterEnabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.CacheClusterEnabled should be set to true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.CacheClusterEnabled is set to false", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "CacheClusterEnabled"], []),
	}
}
