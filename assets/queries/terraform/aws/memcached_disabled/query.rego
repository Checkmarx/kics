package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_elasticache_cluster[name]
	resource.engine == "redis"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticache_cluster",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_elasticache_cluster", name),
		"searchKey": sprintf("resource.aws_elasticache_cluster[%s].engine", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_elasticache_cluster[%s].engine to have Memcached enabled", [name]),
		"keyActualValue": sprintf("resource.aws_elasticache_cluster[%s].engine doesn't enable Memcached", [name]),
	}
}
