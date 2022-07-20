package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	ecc := input.document[i].Resources[name]
	ecc.Type == "AWS::ElastiCache::CacheCluster"
	ecc.Properties.Engine == "redis"

	result := {
		"documentId": input.document[i].id,
		"resourceType": ecc.Type,
		"resourceName": cf_lib.get_resource_name(ecc, name),
		"searchKey": sprintf("Resources.%s.Properties.Engine", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Engine to be 'memcached'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Engine is 'redis'", [name]),
	}
}
