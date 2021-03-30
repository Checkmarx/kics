package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ElastiCache::CacheCluster"
	properties := resource.Properties
	properties.Engine == "memcached"
	to_number(properties.NumCacheNodes) > 1

	properties.AZMode != "cross-az"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.AZMode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AZMode is 'cross-az'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AZMode is 'single-az", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ElastiCache::CacheCluster"
	properties := resource.Properties
	properties.Engine == "memcached"
	to_number(properties.NumCacheNodes) > 1
	object.get(properties, "AZMode", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AZMode is defined and is 'cross-az'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AZMode is not defined, default value is 'single-az'", [name]),
	}
}
