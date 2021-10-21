package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	elasticache := input.document[i].resource.aws_elasticache_cluster[name]

	bom_output = {
		"resource_type": "aws_elasticache_cluster",
		"resource_name": elasticache.cluster_id,
		# memcached or redis
		"resource_engine": get_engine_type(elasticache),
		# TODO: check security group for EC2 classic/ VPC mode
		"resource_accessibility": "unknown",
		"resource_vendor": "AWS",
		"resource_category": "Queues",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_elasticache_cluster[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticache_cluster", name], []),
		"value": json.marshal(bom_output),
	}
}

get_engine_type(aws_elasticache_cluster) = engine_type {
	engine_type := aws_elasticache_cluster.engine_type
} else = engine_type {
	not aws_elasticache_cluster.replication_group_id
	engine_type := "unknown"
}
