package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_elasticache_cluster[name]
	resource.engine == "redis"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticache_cluster",
		"resourceName": name,
		"searchKey": sprintf("resource.aws_elasticache_cluster[%s].engine", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_elasticache_cluster[%s].engine to have Memcached enabled", [name]),
		"keyActualValue": sprintf("resource.aws_elasticache_cluster[%s].engine doesn't enable Memcached", [name]),
	}
}
