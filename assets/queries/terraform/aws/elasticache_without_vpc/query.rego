package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_elasticache_cluster[name]

	not common_lib.valid_key(resource, "subnet_group_name")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticache_cluster",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_elasticache_cluster", name),
		"searchKey": sprintf("aws_elasticache_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_elasticache_cluster[%s].subnet_group_name' should be defined and not null'", [name]),
		"keyActualValue": sprintf("'aws_elasticache_cluster[%s].subnet_group_name' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticache_cluster", name], []),
	}
}
