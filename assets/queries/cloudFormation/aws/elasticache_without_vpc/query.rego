package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	properties := resource.Properties
	resource.Type = "AWS::ElastiCache::CacheCluster"

	not common_lib.valid_key(properties, "CacheSubnetGroupName")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.CacheSubnetGroupName should be defined and not null", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.CacheSubnetGroupName is undefined or null", [key]),
		"searchLine": common_lib.build_search_line(["Resources", key, "Properties"], []),
	}
}
