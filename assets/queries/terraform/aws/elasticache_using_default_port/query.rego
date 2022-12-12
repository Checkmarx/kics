package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_elasticache_cluster[name]
	not common_lib.valid_key(resource, "port")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticache_cluster",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_elasticache_cluster", name),
		"searchKey": sprintf("aws_elasticache_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_elasticache_cluster.port should be defined and not null",
		"keyActualValue": "aws_elasticache_cluster.port is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticache_cluster", name], []),
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.aws_elasticache_cluster[name]

	engines := {"memcached": 11211, "redis": 6379}
	enginePort := engines[e]

	cluster.engine == e
	cluster.port == enginePort

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticache_cluster",
		"resourceName": tf_lib.get_specific_resource_name(cluster, "aws_elasticache_cluster", name),
		"searchKey": sprintf("aws_elasticache_cluster[%s].port", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'port' should not be set to %d", [enginePort]),
		"keyActualValue": sprintf("'port' is set to %d", [enginePort]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticache_cluster", name, "port"], []),
	}
}

