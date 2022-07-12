package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[name]
	resource.Type = "AWS::ElastiCache::ReplicationGroup"
	properties := resource.Properties

	engines := {"memcached": 11211, "redis": 6379}
	enginePort := engines[e]

	lower(properties.Engine) == e
	properties.Port == enginePort

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Port", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Port should not be set to %d", [name, enginePort]),
		"keyActualValue": sprintf("Resources.%s.Properties.Port is set to %d", [name, enginePort]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "Port"], []),
	}
}
