package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document
	elasticache := document[i].Resources[name]
	elasticache.Type == "AWS::ElastiCache::CacheCluster"

	bom_output = {
		"resource_type": "AWS::ElastiCache::CacheCluster",
		"resource_name": get_name(elasticache),
		# memcached or redis
		"resource_engine": elasticache.Properties.Engine,
		"resource_accessibility": "TO DO",
		"resource_encryption": "unknown",
		"resource_vendor": "AWS",
		"resource_category": "In Memory Data Structure",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["Resources", name], []),
		"value": json.marshal(bom_output),
	}
}

get_name(elasticache) = name {
	name := elasticache.Properties.ClusterName
} else = name {
	name := "unknown"
}
