package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_elasticache_cluster[name]
	min_version_string := "4.0.10"

	eval_version_number(resource.engine_version) < eval_version_number(min_version_string)

	result := {
		"documentId": document.id,
		"resourceType": "aws_elasticache_cluster",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_elasticache_cluster", name),
		"searchKey": sprintf("aws_elasticache_cluster[%s].engine_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_elasticache_cluster[%s].engine_version should be compliant with the requirements", [name]),
		"keyActualValue": sprintf("aws_elasticache_cluster[%s].engine_version isn't compliant with the requirements", [name]),
	}
}

eval_version_number(engine_version) = numeric_version {
	version := split(engine_version, ".")
	numeric_version := ((to_number(version[0]) * 100) + (to_number(version[1]) * 10)) + to_number(version[2])
}
