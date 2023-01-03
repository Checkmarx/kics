package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	cluster := input.document[i].resource.aws_elasticache_cluster[name]

	lower(cluster.engine) == "memcached"
	to_number(cluster.num_cache_nodes) > 1
	not cluster.az_mode

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticache_cluster",
		"resourceName": tf_lib.get_specific_resource_name(cluster, "aws_elasticache_cluster", name),
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticache_cluster", name], []),
		"searchKey": sprintf("aws_elasticache_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'az_mode' should be set and must be 'cross-az' in multi nodes cluster",
		"keyActualValue": "'az_mode' is undefined",
		"remediation": "az_mode = \"cross-az\"",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.aws_elasticache_cluster[name]

	lower(cluster.engine) == "memcached"
	to_number(cluster.num_cache_nodes) > 1
	lower(cluster.az_mode) != "cross-az"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticache_cluster",
		"resourceName": tf_lib.get_specific_resource_name(cluster, "aws_elasticache_cluster", name),
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticache_cluster", name, "az_mode"], []),
		"searchKey": sprintf("aws_elasticache_cluster[%s].az_mode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'az_mode' should be 'cross-az' in multi nodes cluster",
		"keyActualValue": sprintf("'az_mode' is '%s'", [cluster.az_mode]),
		"remediation": json.marshal({
			"before": sprintf("%s", [cluster.az_mode]),
			"after": "cross-az"
		}),
		"remediationType": "replacement",
	}
}
