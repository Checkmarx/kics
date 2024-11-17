package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::ElastiCache::CacheCluster"
	properties := resource.Properties
	properties.Engine == "memcached"
	to_number(properties.NumCacheNodes) > 1

	properties.AZMode != "cross-az"

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.AZMode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AZMode is 'cross-az'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AZMode is 'single-az", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::ElastiCache::CacheCluster"
	properties := resource.Properties
	properties.Engine == "memcached"
	to_number(properties.NumCacheNodes) > 1
	not common_lib.valid_key(properties, "AZMode")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AZMode should be defined and is 'cross-az'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AZMode is not defined, default value is 'single-az'", [name]),
	}
}
