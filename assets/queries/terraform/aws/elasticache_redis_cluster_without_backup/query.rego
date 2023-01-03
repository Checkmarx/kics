package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	cluster := input.document[i].resource.aws_elasticache_cluster[name]

	cluster.engine == "redis"
	not common_lib.valid_key(cluster, "snapshot_retention_limit")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticache_cluster",
		"resourceName": tf_lib.get_specific_resource_name(cluster, "aws_elasticache_cluster", name),
		"searchKey": sprintf("aws_elasticache_cluster[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticache_cluster", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'snapshot_retention_limit' should be higher than 0",
		"keyActualValue": "'snapshot_retention_limit' is undefined",
		"remediation": "snapshot_retention_limit = 5",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.aws_elasticache_cluster[name]

	cluster.engine == "redis"
	cluster.snapshot_retention_limit = 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticache_cluster",
		"resourceName": tf_lib.get_specific_resource_name(cluster, "aws_elasticache_cluster", name),
		"searchKey": sprintf("aws_elasticache_cluster[%s].snapshot_retention_limit", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticache_cluster", name, "snapshot_retention_limit"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'snapshot_retention_limit' should be higher than 0",
		"keyActualValue": "'snapshot_retention_limit' is 0",
		"remediation": json.marshal({
			"before": "0",
			"after": "5"
		}),
		"remediationType": "replacement",
	}
}
