package Cx

CxPolicy[result] {
	ecc := input.document[i].Resources[name]
	ecc.Type == "AWS::ElastiCache::CacheCluster"
	ecc.Properties.Engine == "redis"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Engine", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Engine is 'memcached'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Engine is 'redis'", [name]),
	}
}
