package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_elasticache_cluster[name]
	resource.engine != "redis"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticache_cluster",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_elasticache_cluster", name),
		"searchKey": sprintf("resource.aws_elasticache_cluster[%s].engine", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticache_cluster", name, "engine"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_elasticache_cluster[%s].engine should have Redis enabled", [name]),
		"keyActualValue": sprintf("resource.aws_elasticache_cluster[%s].engine doesn't enable Redis", [name]),
		"remediation": json.marshal({
			"before": "memcached",
			"after": "redis"
		}),
		"remediationType": "replacement",
	}
}
