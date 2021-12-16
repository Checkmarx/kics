package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_elasticache_cluster[name]

	not common_lib.valid_key(resource, "subnet_group_name")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_elasticache_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_elasticache_cluster[%s].subnet_group_name' is defined and not null'", [name]),
		"keyActualValue": sprintf("'aws_elasticache_cluster[%s].subnet_group_name' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticache_cluster", name], []),
	}
}
